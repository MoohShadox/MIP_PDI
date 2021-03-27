module prp

using Base

    function match_all(pattern, str)
        m =[parse(Float32,x[1]) for x in eachmatch(pattern, str)]
        if(!isempty(m))
            return (m)
        end;
        return []
    end; 


    function match_Int(pattern, str)
        m =[parse(Int,x[1]) for x in eachmatch(pattern, str)]
        if(!isempty(m))
            return (m)
        end;
        return []
    end; 

    function match_Float(pattern, str)
        m =[parse(Float64,x[1]) for x in eachmatch(pattern, str)]
        if(!isempty(m))
            return (m)
        end;
        return []
    end; 


    mutable struct Client
        x
        y
        h
        L
        L_0
        d::Array{Int}
        end;

    Client() = Client(0,0,0,0,0,[])

    mutable struct PRP
        dist
        n::Int
        l
        u
        f
        C::Float64
        Q
        k
        mc
        clients::Array{Client}
    end;
    PRP() = PRP(0,0,0,0,0,0,0,0,0, [])

function parse_PRP(path)
    prp = PRP()
    open(path,"r") do file
        for ln in eachline(file)
            
            #Parsing Type 
            ar = match_all(r"Type (\d)",ln)
            if(size(ar)[1] > 0)
                prp.dist = ar[1]
            end;
            
            
            #Parsing Number of Clients
            ar = match_all(r"n (\d+)",ln)
            if(size(ar)[1] > 0)
                prp.n = ar[1]
                prp.clients = [Client() for i in range(1, length=prp.n+1)]
            end;
            
            
            #Parsing Number of time periods 
            ar = match_all(r"l (\d+)",ln)
            if(size(ar)[1] > 0)
                prp.l = ar[1]
            end;
            
            #Parsing Unit Production cost 
            ar = match_all(r"u (\d+)",ln)
            if(size(ar)[1] > 0)
                prp.u = ar[1]
            end;
            
            #Parsing Setup Cost
            ar = match_all(r"f (\d+)",ln)
            if(size(ar)[1] > 0)
                prp.f = ar[1]
            end;
            
            #Parsing Production capacity
            ar = match_Float(r"C (\d+e\+\d+)",ln)
            if(size(ar)[1] > 0)
                prp.C = (ar[1])
            end;
            
            #Parsing Vehicle Capacity
            ar = match_all(r"Q (\d+)",ln)
            if(size(ar)[1] > 0)
                prp.Q = ar[1]
            end;
            
            
            #Parsing Vehicle Capacity
            ar = match_all(r"k (\d+)",ln)
            if(size(ar)[1] > 0)
                prp.k = ar[1]
            end;
            
            if(prp.dist == 2)
                ar = match_all(r"mc (\d+)",ln)
                if(size(ar)[1] > 0)
                prp.mc = ar[1]
                end;
            end;
            
            ar = match_all(r"k (\d+)",ln)
            if(size(ar)[1] > 0)
                prp.k = ar[1]
            end;
            
            m = match(r" ?(\d+) ?(\d+) ?(\d+) ?: ?h ?(\d+) ?L ?(\d+) ?L0 ?(\d+) ?", ln)
            if(m != nothing)
                ind = parse(Int,m[1])
                if(size(prp.clients)[1] > 0)
                    C = Client()
                    prp.clients[ind+1].x = parse(Int,m[2])
                    prp.clients[ind+1].y = parse(Int,m[3])
                    
                    prp.clients[ind+1].h = parse(Int,m[4])
                    prp.clients[ind+1].L = parse(Int,m[5])
                    prp.clients[ind+1].L_0 = parse(Int,m[6])
                    end;
            end;
            
            m = match(r" ?(\d+) ?(\d+) ?(\d+) ?: ?h ?(\d+) ?L ?(\d+e\+\d+) ?L0 ?(\d+) ?", ln)
            if(m != nothing)
                ind = parse(Int,m[1])
                if(size(prp.clients)[1] > 0)
                    C = Client()
                    prp.clients[ind+1].x = parse(Int,m[2])
                    prp.clients[ind+1].y = parse(Int,m[3])
                    
                    prp.clients[ind+1].h = parse(Int,m[4])
                    prp.clients[ind+1].L = parse(Float32,m[5])
                    prp.clients[ind+1].L_0 = parse(Int,m[6])
                    end;
            end;
            
        end;
    end;
    
open(path,"r") do f
    ch = read(f, String)
    ch = (rsplit(ch,"d")[2])
    ch = rsplit(ch,"\n")
        for i in ch
            if(length(i) > 0)
                ar = match_Int(r" ?(\d+) ?",i)
                prp.clients[ar[1]+1].d = ar[2:end]
            end
        end
end
return prp
end;

export parse_PRP, PRP, Client

end;