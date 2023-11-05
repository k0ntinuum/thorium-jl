using LinearAlgebra
using Printf

str(v,s)  = join(map(i -> i ? "|"*s : "O"*s , v))
print_key(k) = for i in 1:size(k)[begin] print(str(k[i,:]," "),"\n") end
print_vec(v) = print(str(v,""),"\n")
key(n) = rand(Bool,n,n)

spin_row(k,i,p) = circshift(k[i,:], k[i,i] + p + 1)
spin_col(k,i,p) = circshift(k[:,i], k[i,i] + p + 1)

# spin!(k,i) =for j in 1:size(k)[begin] Bool((j+i)%2) ? k[j,:] = spin_row(k,j) : k[:,j] = spin_col(k,j) end
rgb(r,g,b) =  "\e[38;2;$(r);$(g);$(b)m"

red() = rgb(255,0,0);yellow() = rgb(255,255,0);white() = rgb(255,255,255);gray(h) = rgb(h,h,h)
blue() = rgb(0,0,255);

function spin(q,p)
    k = copy(q)
    for j in 1:n[begin]
        if  Bool((j+p)%2) k[j,:] = spin_row(k,j,p)
        else k[:,j] = spin_col(k, j,p)
        end
    end
    k
end

function encode(p,q)
    k = copy(q)
    c = Bool[]
    for i in eachindex(p)
        push!(c,Bool((tr(k) + p[i])%2))
        k = spin(k,p[i])
    end
    c
end

function decode(c,q)
    k = copy(q)
    p = Bool[]
    for i in eachindex(c)
        push!(p,Bool((tr(k) + c[i])%2))
        k = spin(k,p[i])
    end
    p
end
function encrypt(p, q, r)
    for i in 1:r
        k = spin(q,i)
        p = encode(p,k)
        p = reverse(p)
    end
    p
end

function decrypt(p, q, r)
    for i in 1:r
        k = spin(q,r + 1 - i)
        p = reverse(p)
        p = decode(p,k)
    end
    p
end

function demo()
    print(white(),"k =\n", gray(150))
    print_key(k)
    print("\n",white(),"r = \n",gray(150),r,"\n\n")
    for i in 1:w
    	p = rand(Bool,t)
        print(white(),"f( ", red(), str(p), white()," ) = ")
        c  = encrypt(p,k,r)
        #c = encode(p,k)
        print(yellow(),str(c), "    ")
        e = p .== c
        print(gray(100),str(e), " \n")
        #d = decode(c,k)
        d  = decrypt(c,k,r)
        if p != d @printf "ERROR" end
    	# 
    	# 
    	
    end
    print(white())
end

r = 50
n = 32
k = key(n)
t = 32
w= 18
demo()
    	