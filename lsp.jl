
module lsp

include("prp.jl")

using Main.prp
using JuMP
using Cbc

export add_lsp

function add_lsp(prp_1::PRP, model::Model)

    l = convert(Int,prp_1.l)
    n = convert(Int,prp_1.n)
    L0s = [i.L_0 for i in prp_1.clients]
    Ls = [i.L for i in prp_1.clients]
    h = [i.h for i in prp_1.clients]
    d1 = [i.d for i in prp_1.clients[2:end]]
    d = hcat(d1...)'    


    #Quantité stockée chez i a la période j
    I = @variable(model,0 <= I[0:n, 0:l] )
    for (i,j) in zip(L0s, I[:,0])
        @constraint(model, i == j)
    end

    #Quantité produite a la période i
    p = @variable(model, 0<= p[1:l])

    #Lancement de la production a l'instant l
    @variable(model,0 <= y[1:l] <= 1,Bin)

    #Quantité produite pour i a l'instant t
    @variable(model,0 <= q[1:n, 1:l] )

    ##Evolution de la Quantité du fournisseur au fil de la production
    for t=1:l
        @constraint(model, I[0,t-1] + p[t] == sum(q[:,t]) + I[0,t])
    end



    C = convert(Int, prp_1.C)
    #Pour éviter les problèmes d'instabilité numérique
    if(C > 1e5)
        C = 1e5
    end
    #Pour produire il faut lancer la production
    for t = 1:l
        @constraint(model, p[t] <= C*y[t] )
    end


    #Consommation des ressources par la demande
    for i = 1:n
        for t = 1:l
            @constraint(model, I[i,t-1] + q[i,t] == d[i,t] + I[i,t])
        end
    end

    #La Quantité ne doit jamais dépasser une borne supérieure
    for i = 0:n
        for t = 1:l
            if(i == 0)
                @constraint(model, I[i,t-1]<= Ls[i+1])
            else
                @constraint(model, I[i,t-1] + q[i,t] <= Ls[i+1])
            end
        end
    end

    #La fonction objectif 
    e = prp_1.u*p + prp_1.f*y
    print(e)
    @objective(model,Min,sum(prp_1.u*p + prp_1.f*y + (h'*I[1:n,:])'[2:end]))

end;





end;
