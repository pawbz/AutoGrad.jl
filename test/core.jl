include("header.jl")
using Statistics

@testset "core" begin

    # Issue #71.1: AutoGrad error in backprop when iterating dict
    u = [rand(2,3), rand(2)]
    v = [rand(1,2), rand(1)]
    m = Dict(:u=>u, :v=>v)
    x,y = rand(3,4),rand(1,4)
    pred(m,x) = foldl((x,w)->w[1]*x .+ w[2], [m[:u],m[:v]], init=x)
    loss(m,x,y) = mean(abs2, pred(m,x)-y)
    ∇ = grad(loss)
    @test isa(loss(m,x,y), Real)
    @test isa(∇(m,x,y), Dict)
    l2(ws) = mean(mean.(abs2, ws))
    loss(m,x,y) = mean(abs2, pred(m,x)-y) + mean(l2.(collect(values(m))))
    ∇ = grad(loss)
    @test isa(loss(m,x,y), Real)
    @test isa(∇(m,x,y), Dict)

    # Issue #71.2
    m = [rand(1,3), rand(1)]
    x,y = rand(3,4),rand(1,4)
    pred(m,x) = m[1]*x .+ m[2]
    loss(m,x,y) = mean(abs2, pred(m,x) .- y)
    ∇ = grad(loss)
    @test isa(∇(m,x,y), Array)
    loss(m,x,y) = mean(abs2, pred(m,x) .- y) + mean(mean.(abs2, m))
    ∇ = grad(loss)
    @test isa(∇(m,x,y), Array)

end
