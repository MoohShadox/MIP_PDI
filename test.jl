#
using JuMP
using Clp
#


m = Model()


set_optimizer(m, Clp.Optimizer)
@variable(m, 0 <= x )
@variable(m, 0 <= y )
@constraint(m, con, x+y >= 2)
@objective(m, Max, 2*x + 3*y)

print(m)

optimize!(m)


println("Termination status : ", termination_status(m))
println("Primal status      : ", primal_status(m))
println("Dual status      : ", dual_status(m))