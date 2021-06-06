using JuMP, Clp

# Preparing an optimization model
m = Model(Clp.Optimizer)

n=5
Q= 10
c = rand(Int8, (n, n))

# Declaring variables
x = @variable(m, 0 <= x[0:n,0:n] <= 1)
u = @variable(m, 0 <= u[0:n] <= Q)
d = @variable(m, 0 <= d[0:n] <= Q)

for i = 0:n
    @constraint(m,x[i,i]==0)
end

# Setting the objective
@objective(m, Min,sum(c[i,j]*x[i,j] for i=1:n for j=1:n))

# Adding constraints
for i = 0:n
    @constraint(m,sum(x[i,j] for j=1:n)==1)
    @constraint(m,sum(x[j,i] for j=1:n)==1)
end

for i = 1:n
    for j = 1:n
        @constraint(m,(u[i]+d[j])==u[j])
    end
end

# Printing the prepared optimization model
print(m)

# Solving the optimization problem
optimize!(m)

# Printing the optimal solutions obtained
println("Optimal Solutions:")
println("x = ", JuMP.value.(x))

#https://medium.com/cmsa-algorithm-for-the-service-of-the-capacitated/state-of-art-of-the-capacitated-vehicle-rooting-problem-30ad4de6c2e9
