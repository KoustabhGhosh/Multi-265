# Sage code to find all matrix
# list all choices when number of zeros is less than 1
lc0 = []
for x0 in range(-1,4):
    for x1 in range(-1,4):
        for x2 in range(-1,4):
            for x3 in range(-1,4):
                for x4 in range(-1,4):
                    for x5 in range(-1,4):
                        
                        x= (x0,x1,x2,x3,x4,x5)
                        if x.count(0)<2:
                            lc0.append(x)
#list all full rank matrix
print(len(lc0))
fr = []         
ch =[]
for x in lc0:
    Matrix=  matrix(GF((2**(26)-5)),[[x[0],x[1],x[2],x[3],x[4],x[5]],[x[1],x[2],x[3],x[4],x[5],x[0]],[x[2],x[3],x[4],x[5],x[0],x[1]],[x[3],x[4],x[5],x[0],x[1],x[2]],[x[4],x[5],x[0],x[1],x[2],x[3]],[x[5],x[0],x[1],x[2],x[3],x[4]]])
    rFull = Matrix.rank()
    if rFull ==6:
        fr.append(Matrix)
        ch.append(x)
print(len(fr))
print(len(ch))
#now all 5*5 has full rank
fr5 = []
ch5 = []
for i in range(len(fr)):
    mat56 = []
    for j in range(1):
        for k in range(j+1,2):
            for l in range(k+1,3):
                for m in range(l+1,4):
                    for n in range(m+1,5):
                        fiveSix  = matrix(GF((2**(26))-5),[fr[i][j],fr[i][k],fr[i][l],fr[i][m],fr[i][n]]) 
                        mat56.append(fiveSix.transpose())

                        
    mat55rank = []
    for el in mat56:
        for j in range(1):
            for k in range(j+1,6):
                for l in range(k+1,6):
                    for m in range(l+1,6):
                        for n in range(m+1,6):
                            five  = matrix(GF((2**26)-5),[el[j],el[k],el[l],el[m],el[n]])
                            mat55rank.append(five.rank())
    if min(mat55rank)>4:
        fr5.append(fr[i])
        ch5.append(ch[i])
print(len(fr5))
print(len(ch5))
#now all 4*4 has full rank
fr4 = []
ch4 = []
for i in range(len(fr5)):
    mat46 = []
    for j in range(1):
        for k in range(j+1,2):
            for l in range(k+1,3):
                for m in range(l+1,4):
                    fourSix  = matrix(GF((2**(26))-5),[fr5[i][j],fr5[i][k],fr5[i][l],fr5[i][m]]) 
                    mat46.append(fourSix.transpose())

                        
    mat44rank = []
    for el in mat46:
        for j in range(6):
            for k in range(j+1,6):
                for l in range(k+1,6):
                    for m in range(l+1,6):
                            three  = matrix(GF((2**26)-5),[el[j],el[k],el[l],el[m]])
                            mat44rank.append(three.rank())
    if min(mat44rank)>3:
        fr4.append(fr5[i])
        ch4.append(ch5[i])
print(len(fr4))
print(len(ch4))
#now all 3*3 has full rank
fr3 = []
ch3 = []
for i in range(len(fr4)):
    mat36 = []
    for j in range(1):
        for k in range(j+1,2):
            for l in range(k+1,3):
                
                threeSix  = matrix(GF((2**(26))-5),[fr4[i][j],fr4[i][k],fr4[i][l]]) 
                mat36.append(threeSix.transpose())

                        
    mat33rank = []
    for el in mat36:
        for j in range(6):
            for k in range(j+1,6):
                for l in range(k+1,6):
                    
                    three  = matrix(GF((2**26)-5),[el[j],el[k],el[l]])
                    mat33rank.append(three.rank())
    if min(mat33rank)>2:
        fr3.append(fr4[i])
        ch3.append(ch4[i])
print(len(fr3))
print(len(ch3))
print(ch3)
#print(Arr5)
