using JuMP
using CPLEX
using ExcelReaders

function readULSdesdeExcel(fichero::String)
    f=open(fichero)
    T=parse(Int64,readline(f))
    cl=parse(Int64,readline(f))
    cs=parse(Int64,readline(f))
    d=zeros(T)
    for i in 1:T
        d[i]=parse(Int64,readline(f))
    end
    close(f)
    #T=10
    #cl=100
    #cs=1
    #d=[1;2;3;4;5;6;7;8;9;10]
    println(T)
    println(cs)
    println(cl)
    println(d)
    return T,cs,cl,d
end

function solveULS(fichero::String, solver=CplexSolver(CPX_PARAM_SCRIND=1), valid::Bool = true)

    T, cs, cl, d = readULSdesdeExcel(fichero)
    m = Model(solver = solver)
    @variable(m, y[1:T], Bin)
    @variable(m, x[i = 1:T] >= 0)
    @variable(m, s[1:T] >= 0)

    @objective(m, Min, sum(cl*y[t] + cs*s[t] for t in 1:T))
    @constraint(m, activation[t = 1:T], x[t] <= sum(d[t:T])*y[t])
    @constraint(m, balance[t = 1:T], (t>1?s[t-1]:0) + x[t] == s[t] + d[t])
    print(m)
    status = solve(m)
    f = open("c:\\Users\\Jordi\\Desktop\\imgs\\out.txt","w")
    print(f,getobjectivevalue(m))
    print(f,"\r\n")
    for i in 1:T
        print(f,getvalue(x[i]))
        print(f," \r\n")
    end
    for i in 1:T
        print(f,getvalue(y[i]))
        print(f," \r\n")
    end
    for i in 1:T
        print(f,getvalue(s[i]))
        print(f," \r\n")
    end
    close(f)
    println("t: ",T)
end

solveULS("c:\\Users\\Jordi\\Desktop\\imgs\\in.txt")
#readline(STDIN)
