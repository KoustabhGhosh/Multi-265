.text
.align 8
.global Multi265field 
.type	Multi265field, %function;

Multi265field:
	subs		r2, r2, #36
	bcc		.Lloop3_done
	
.Lloop3Once:

	vld1.32		{q13,q14}, [r0]!			
	vld1.32 	{d30}, [r0]
	add		r0, r0, #4
	
	vmov.i32    	q0  , #0
	vmov.i32    	q1  , #0
	vmov.i32    	q2  , #0
	vmov.i32    	q6  , #0
	vmov.i32    	q7  , #0	
	
	
	vshl.u64    	d12, d26, #40			
	vext.8      	d0, d12, d13, #5			
        
	vshl.u64    	d12, d26, #16
	vshr.u64    	d12, d12, #40
	vmov		s1, s24

	vshr.u64    	d13, d26, #48
	vshl.u64	d12, d27, #56
	vshr.u64	d12, d12, #40
	vorr.u64	d13, d13, d12
	vmov		s2, s26
	   
	vshl.u64    	d12,d27,#32
	vshr.u64    	d12,d12,#40
	vmov        	s3,s24
    
    
	vshl.u64    	d12,d27,#8
	vshr.u64    	d12,d12,#40
	vmov        	s4,s24
    
	vshr.u64    	d12,d27,#56
	vshl.u64    	d13,d28,#48
	vshr.u64    	d13,d13,#40
	veor.32     	d13,d13,d12
	vmov        	s5,s26
    
	vshl.u64    	d12,d28,#24
	vshr.u64    	d12,d12,#40
	vmov        	s6,s24
    
    
	vshr.u64    	d12,d28,#40
	vmov        	s7,s24
    
	vshl.u64    	d12,d29,#40
	vshr.u64    	d12,d12,#40
	vmov		s8, s24
    
	vshl.u64    	d12,d29,#16
	vshr.u64    	d12,d12,#40
	vmov		s9, s24
    
	vshr.u64    	d12,d29,#48
	vshl.u64	d13,d30,#56
	vshr.u64	d13,d13,#40
	veor.32     	d12,d13,d12
	vmov		s10, s24
    
	vshl.u64	d12,d30,#32
	vshr.u64	d12,d12,#40
	vmov		s11, s24			// now q0 has X0,X1,X2,X3  q1 has X4,X5,Y0,Y1  q2 has Y2,Y3,Y4,Y5
    
	
	vmov		d12, d4
	vmov		d4, d2				
	vmov		d2, d1			
	vmov		d1, d3
	vmov		d3, d12				// q0 contains X0,X1,Y0,Y1 - q1 contains X2,X3,Y2,Y3 - q2 contains X4,X5,Y4,Y5
	
	
	vadd.u32	q10, q0, q1   			// q10 contains X0+X2,X1+X3,Y0+Y2,Y1+Y3  
	vadd.u32	q11, q0, q2   			// q11 contains X0+X4,X1+X5,Y0+Y4,Y1+Y5  
	vadd.u32	q12, q1, q2   			// q12 contains X2+X4,X3+X5,Y2+Y4,Y3+Y5  
	
	vmov.u32	q6, #3	
	vmul.u32	q7, q12, q6			// q7 contains 3(X2+X4),3(X3+X5),3(Y2+Y4),3(Y3+Y5) 
	vrev64.32	q3, q0				// q3 contains X1,X0,Y1,Y0
	vadd.u32	q3, q3, q0			// q3 contains X0+X1,X0+X1,Y0+Y1,Y0+Y1
	
	vadd.u32	q3, q7, q3 			// q3 contains 3(X2+X4)+X0+X1,3(X3+X5)+X0+X1,3(Y2+Y4)+Y0+Y1,3(Y3+Y5)+Y0+Y1
	vrev64.32	q9, q1				// q9 contains X3,X2,Y3,Y2 
	vadd.u32	q3, q9, q3 			// q3 contains 3(X2+X4)+X0+X1+X3,3(X3+X5)+X0+X1+X2,3(Y2+Y4)+Y0+Y1+Y3,3(Y3+Y5)+Y0+Y1+Y2   P0, ? ,Q0,?
	vrev64.32	q12, q12			// q12 contains X3+X5,X2+X4,Y3+Y5,Y2+Y4
	vadd.u32	q4, q7, q12			// q4 contains 3(X2+X4)+X3+X5,3(X3+X5)+X2+X4,3(Y2+Y4)+Y3+Y5,3(Y3+Y5)+Y2+Y4
	vadd.u32	q4, q0, q4			// q4 contains 3(X2+X4)+X3+X5+X0,3(X3+X5)+X2+X4+X1,3(Y2+Y4)+Y3+Y5+Y0,3(Y3+Y5)+Y2+Y4+Y1  ?, P1, ?, Q1
	vrev64.32	q4, q4				// q4 contains P1, ?, Q1, ? 
	vtrn.32		q3, q4				// q3 contains P0,P1,Q0,Q1 
	
	
	
	vmul.u32	q7, q11, q6			// q7 contains 3(X0+X4),3(X1+X5),3(Y0+Y4),3(Y1+Y5)
	vadd.u32	q4, q7, q12			// q4 contains 3(X0+X4)+X3+X5,3(X1+X5)+X2+X4,3(Y0+Y4)+Y3+Y5,3(Y1+Y5)+Y2+Y4
	vadd.u32	q4, q1, q4			// q4 contains 3(X0+X4)+X3+X5+X2,3(X1+X5)+X2+X4+X3,3(Y0+Y4)+Y3+Y5+Y2,3(Y1+Y5)+Y2+Y4+Y3  P2, ?, Q2, ?	 
	vrev64.32	q7, q7				// q7 contains 3(X1+X5),3(X0+X4),3(Y1+Y5),3(Y0+Y4)
	vadd.u32	q7, q7, q11			// q7 contains 3(X1+X5)+X0+X4,3(X0+X4)+X1+X5,3(Y1+Y5)+Y0+Y4,3(Y0+Y4)+Y1+Y5
	vadd.u32	q7, q7, q9			// q7 contains 3(X1+X5)+X0+X4+X3,3(X0+X4)+X1+X5+X2,3(Y1+Y5)+Y0+Y4+Y3,3(Y0+Y4)+Y1+Y5+Y2   P3, ? , Q3, ?
	vtrn.32		q4, q7				// q4 contains P2,P3,Q2,Q3
	
	vmul.u32	q7, q10, q6			// q7 contains 3(X0+X2),3(X1+X3),3(Y0+Y2),3(Y1+Y3)
	vrev64.32	q11, q11			// q11 contains  X1+X5,X0+X4,Y1+Y5,Y0+Y4
	vadd.u32	q11, q11, q2			// q11 contains  X1+X5+X4,X0+X4+X5,Y1+Y5+Y4,Y0+Y4+Y5
	vadd.u32	q5, q7, q11			// q5 contains 3(X0+X2)+X1+X5+X4,3(X1+X3)+X0+X4+X5,3(Y0+Y2)+Y1+Y5+Y4,3(Y1+Y3)+Y0+Y4+Y5  P4, ?, Q4, ?
	vrev64.32	q10, q10			// q10 contains X1+X3,X0+X2,Y1+Y3,Y0+Y2
	vadd.u32	q6, q2, q10			// q6 contains X1+X3+X4,X0+X2+X5,Y1+Y3+Y4,Y0+Y2+Y5
	vadd.u32	q6, q6, q7			// q6 contains 3(X0+X2)+X1+X3+X4,3(X1+X3)+X0+X2+X5,3(Y0+Y2)+Y1+Y3+Y4,3(Y1+Y3)+Y0+Y2+Y5   ?, P5, ?, Q5
	vrev64.32	q6, q6				// q6 contains P5, ? , Q5, ?
	vtrn.32		q5, q6				// q5 contains P4, P5, Q4, Q5
	

	/*
	Now we have these: 
	q0 		X0,X1,Y0,Y1
	q1 		X2,X3,Y2,Y3
	q2 		X4,X5,Y4,Y5
	q3		P0,P1,Q0,Q1
	q4		P2,P3,Q2,Q3
	q5		P4,P5,Q4,Q5
	*/
	
	
	vmull.u32	q3, d6, d7			// q3 contains P0Q0,P1Q1 
	vmull.u32	q4, d8, d9			// q4 contains P2Q2,P3Q3
	vmull.u32	q5, d10, d11			// q5 contains P4Q4,P5Q5
	

	/* Now reduction */
	mov 		r5, #2				// our prime number is 2^26-5 (in form of 2^ell-c)
	lsl		r5, #25				// r5 contains 2^27 or 2^(ell+1)
	sub		r5, r5, #1			// r6 contains 2^ell - 1
	vmov.i32    	q7  , #0
	vmov.i32    	q8  , #0
	
	vmov		s28 , r5						
	vmov		s30, r5
	
	vmov 		q8, q7				// q8: d16, d17 contain 2^ell - 1
					
	vmov.i32	q9, #5
	vshr.u64	q9, #32
	

	/*was P0Q0 d8 P1Q1 d9 --> P0Q0 d6 P1Q1 d7*/
	vand.u64	q10, q8, q3		 	// a0 = a&(2^ell - 1)
	vshr.u64	q3, #26				// a1 = a>>ell
	vmov.i32    	q11  , #0
	vmov.i32    	q12  , #0
	vmlal.u32	q11, d6, d18			// d0*5 = c*a1
	vmlal.u32	q12, d7, d19
	vadd.u64	q3, q11, q10			// c*a1+a0
	vadd.u64	q11, q12, q10
	vmov		d7, d22
		
	
	vand.u64	q10, q8, q3		 	// a0 = a&(2^ell - 1)
	vshr.u64	q3, #26				// a1 = a>>ell
	vmov.i32    	q11  , #0
	vmov.i32    	q12  , #0
	vmlal.u32	q11, d6, d18			// d0*5 = c*a1
	vmlal.u32	q12, d7, d19
	vadd.u64	q3, q11, q10			// c*a1+a0
	vadd.u64	q11, q12, q10
	vmov		d7, d22
	
	/*reduced P0Q0 is in d6, and reduced P1Q1 is in d7 q3*/
	
	
	/*was P2Q2 d10 P3Q3 d11 --> P2Q2 d8 P3Q3 d9*/
	vand.u64	q10, q8, q4			// a0 = a&(2^ell - 1)
	vshr.u64	q4, #26				// a1 = a>>ell
	vmov.i32    	q11  , #0
	vmov.i32    	q12  , #0
	vmlal.u32	q11, d8, d18			// d0*5 = c*a1
	vmlal.u32	q12, d9, d19
	vadd.u64	q4, q11, q10			// c*a1+a0
	vadd.u64	q11, q12, q10
	vmov		d9, d22
		
	
	vand.u64	q10, q8, q4			// a0=a&(2^ell - 1)
	vshr.u64	q4, #26				// a1=a>>ell
	vmov.i32    	q11  , #0
	vmov.i32    	q12  , #0
	vmlal.u32	q11, d8, d18			// d0*5 = c*a1
	vmlal.u32	q12, d9, d19
	vadd.u64	q4, q11, q10			// c*a1+a0
	vadd.u64	q11, q12, q10
	vmov		d9, d22
	
				
	/*reduced P2Q2 is in d8, and reduced P3Q3 is in d9 q4*/
	
	/*was P4Q4 d12 P5Q5 d13 --> P4Q4 d10 P5Q5 d11*/
	vand.u64	q10, q8, q5			// a0 = a&(2^ell - 1)
	vshr.u64	q5, #26				// a1 = d6>>ell=a>>ell
	vmov.i32    	q11  , #0
	vmov.i32    	q12  , #0
	vmlal.u32	q11, d10, d18			// d0*5 = c*a1
	vmlal.u32	q12, d11, d19
	vadd.u64	q5, q11, q10			// c*a1+a0
	vadd.u64	q11, q12, q10
	vmov		d11, d22
		
	
	vand.u64	q10, q8, q5			// a0 = a&(2^ell - 1)
	vshr.u64	q5, #26				// a1 = a>>ell
	vmov.i32    	q11  , #0
	vmov.i32    	q12  , #0
	vmlal.u32	q11, d10, d18			// d0*5 = c*a1
	vmlal.u32	q12, d11, d19
	vadd.u64	q5, q11, q10			// c*a1+a0
	vadd.u64	q11, q12, q10
	vmov		d11, d22
				
	/*reduced P4Q4 is in d10, and reduced P5Q5 is in d11 q5*/
	
	/*
	Now we have these: 
	q0 		X0,X1,Y0,Y1
	q1 		X2,X3,Y2,Y3
	q2 		X4,X5,Y4,Y5
	q3   reduced  	P0Q0,P1Q1
	q4   reduced	P2Q2,P3Q3
	q5   reduced	P4Q4,P5Q5
	*/
	
	
	vmull.u32	q0, d0, d1		  	// q0 contains X0Y0,X1Y1 
	vmull.u32	q1, d2, d3			// q1 contains X2Y2,X3Y3
	vmull.u32	q2, d4, d5			// q2 contains X4Y4,X5Y5
	
	
	
	/*X0Y0 d0 X1Y1 d1*/
	vand.u64	q10, q8, q0		 	// a0 = a&(2^ell - 1)
	vshr.u64	q0, #26						// a1 = d6>>ell=a>>ell
	vmov.i32    	q11  , #0
	vmov.i32    	q12  , #0
	vmlal.u32	q11, d0, d18			// d0*5 = c*a1
	vmlal.u32	q12, d1, d19
	vadd.u64	q0, q11, q10			// c*a1+a0
	vadd.u64	q11, q12, q10
	vmov		d1, d22
		
		
	vand.u64	q10, q8, q0			// a0 = a&(2^ell - 1)
	vshr.u64	q0, #26						// a1 = d6>>ell=a>>ell
	vmov.i32    	q11  , #0
	vmov.i32    	q12  , #0
	vmlal.u32	q11, d0, d18			// d0*5 = c*a1
	vmlal.u32	q12, d1, d19
	vadd.u64	q0, q11, q10			// c*a1+a0
	vadd.u64	q11, q12, q10
	vmov		d1, d22
	
	/*reduced X0Y0 is in d0, and reduced X1Y1 is in d1 q0*/
	
	/*X2Y2 d2 X3Y3 d3*/
	vand.u64	q10, q8, q1 			// a0 = a&(2^ell - 1)
	vshr.u64	q1, #26				// a1 = d6>>ell=a>>ell
	vmov.i32    	q11  , #0
	vmov.i32    	q12  , #0
	vmlal.u32	q11, d2, d18			// d0*5 = c*a1
	vmlal.u32	q12, d3, d19
	vadd.u64	q1, q11, q10			// c*a1+a0
	vadd.u64	q11, q12, q10
	vmov		d3, d22
	
	
	vand.u64	q10, q8, q1 			// a0 = a&(2^ell - 1)
	vshr.u64	q1, #26				// a1 = d6>>ell=a>>ell
	vmov.i32    	q11  , #0
	vmov.i32    	q12  , #0
	vmlal.u32	q11, d2, d18			// d0*5 = c*a1
	vmlal.u32	q12, d3, d19
	vadd.u64	q1, q11, q10			// c*a1+a0
	vadd.u64	q11, q12, q10
	vmov		d3, d22
	

	/*reduced X2Y2 is in d2, and reduced X3Y3 is in d3 q1*/
	
	/*X4Y4 d4 X5Y5 d5*/	
	vand.u64	q10, q8, q2			// a0 = a&(2^ell - 1)
	vshr.u64	q2, #26				// a1 = d6>>ell=a>>ell
	vmov.i32    	q11  , #0
	vmov.i32    	q12  , #0
	vmlal.u32	q11, d4, d18			// d0*5 = c*a1
	vmlal.u32	q12, d5, d19
	vadd.u64	q2, q11, q10			// c*a1+a0
	vadd.u64	q11, q12, q10
	vmov		d5, d22
	
	
	vand.u64	q10, q8, q2			// a0 = a&(2^ell - 1)
	vshr.u64	q2, #26				// a1 = d6>>ell=a>>ell
	vmov.i32    	q11  , #0
	vmov.i32    	q12  , #0
	vmlal.u32	q11, d4, d18			// d0*5 = c*a1
	vmlal.u32	q12, d5, d19
	vadd.u64	q2, q11, q10			// c*a1+a0
	vadd.u64	q11, q12, q10
	vmov		d5, d22
	
	/*reduced X4Y4 is in d4, and reduced X5Y5 is in d5 q2*/
	
	/*
	Now we have these: 
	q3		reduced  	P0Q0,P1Q1
	q4		reduced		P2Q2,P3Q3
	q5		reduced		P4Q4,P5Q5
	q0		reduced		X0Y0,X1Y1	
	q1		reduced		X2Y2,X3Y3
	q2		reduced		X4Y4,X5Y5
	*/
	
	vmov 	s1,s2
	vmov	s2,s4
	vmov	s3,s6
	vmov	s4,s8			// Now q0: X0Y0, X1Y1, X2Y2, X3Y3
	vmov	s5,s10    
	vmov	s6,s12
	vmov	s7,s14
	vmov	s8,s16
	vmov	s9,s18
	vmov	s10,s20
	vmov	s11,s22
		
	vst1.8		{q0,q1}, [r1]!
	vst1.8		{q2}, [r1]!	
	
	subs		r2, r2, #36
	bcc		.Lloop3_done
	
.Lloop3:

	vld1.32		{q13,q14}, [r0]!			
	vld1.32 	{d30}, [r0]
	add		r0, r0, #4
	
	vmov.i32    	q0  , #0
	vmov.i32    	q1  , #0
	vmov.i32    	q2  , #0
	vmov.i32    	q6  , #0
	vmov.i32    	q7  , #0	
	
	
	vshl.u64    	d12, d26, #40			
	vext.8      	d0, d12, d13, #5			
        
	vshl.u64    	d12, d26, #16
	vshr.u64    	d12, d12, #40
	vmov		s1, s24

	vshr.u64    	d13, d26, #48
	vshl.u64	d12, d27, #56
	vshr.u64	d12, d12, #40
	vorr.u64	d13, d13, d12
	vmov		s2, s26
	   
	vshl.u64    	d12,d27,#32
	vshr.u64    	d12,d12,#40
	vmov        	s3,s24
    
    
	vshl.u64    	d12,d27,#8
	vshr.u64    	d12,d12,#40
	vmov        	s4,s24
    
	vshr.u64    	d12,d27,#56
	vshl.u64    	d13,d28,#48
	vshr.u64    	d13,d13,#40
	veor.32     	d13,d13,d12
	vmov        	s5,s26
    
	vshl.u64    	d12,d28,#24
	vshr.u64    	d12,d12,#40
	vmov        	s6,s24
    
    
	vshr.u64    	d12,d28,#40
	vmov        	s7,s24
    
	vshl.u64    	d12,d29,#40
	vshr.u64    	d12,d12,#40
	vmov		s8, s24
    
	vshl.u64    	d12,d29,#16
	vshr.u64    	d12,d12,#40
	vmov		s9, s24
    
	vshr.u64    	d12,d29,#48
	vshl.u64	d13,d30,#56
	vshr.u64	d13,d13,#40
	veor.32     	d12,d13,d12
	vmov		s10, s24
    
	vshl.u64	d12,d30,#32
	vshr.u64	d12,d12,#40
	vmov		s11, s24			// now q0 has X0,X1,X2,X3  q1 has X4,X5,Y0,Y1  q2 has Y2,Y3,Y4,Y5
	
	vmov		d12, d4
	vmov		d4, d2				
	vmov		d2, d1			
	vmov		d1, d3
	vmov		d3, d12				// q0 contains X0,X1,Y0,Y1 - q1 contains X2,X3,Y2,Y3 - q2 contains X4,X5,Y4,Y5
	
	
	vadd.u32	q10, q0, q1   			// q10 contains X0+X2,X1+X3,Y0+Y2,Y1+Y3  
	vadd.u32	q11, q0, q2   			// q11 contains X0+X4,X1+X5,Y0+Y4,Y1+Y5  
	vadd.u32	q12, q1, q2   			// q12 contains X2+X4,X3+X5,Y2+Y4,Y3+Y5  
	
	vmov.u32	q6, #3	
	vmul.u32	q7, q12, q6			// q7 contains 3(X2+X4),3(X3+X5),3(Y2+Y4),3(Y3+Y5) 
	vrev64.32	q3, q0				// q3 contains X1,X0,Y1,Y0
	vadd.u32	q3, q3, q0			// q3 contains X0+X1,X0+X1,Y0+Y1,Y0+Y1
	
	vadd.u32	q3, q7, q3 			// q3 contains 3(X2+X4)+X0+X1,3(X3+X5)+X0+X1,3(Y2+Y4)+Y0+Y1,3(Y3+Y5)+Y0+Y1
	vrev64.32	q9, q1				// q9 contains X3,X2,Y3,Y2 
	vadd.u32	q3, q9, q3 			// q3 contains 3(X2+X4)+X0+X1+X3,3(X3+X5)+X0+X1+X2,3(Y2+Y4)+Y0+Y1+Y3,3(Y3+Y5)+Y0+Y1+Y2   P0, ? ,Q0,?
	vrev64.32	q12, q12			// q12 contains X3+X5,X2+X4,Y3+Y5,Y2+Y4
	vadd.u32	q4, q7, q12			// q4 contains 3(X2+X4)+X3+X5,3(X3+X5)+X2+X4,3(Y2+Y4)+Y3+Y5,3(Y3+Y5)+Y2+Y4
	vadd.u32	q4, q0, q4			// q4 contains 3(X2+X4)+X3+X5+X0,3(X3+X5)+X2+X4+X1,3(Y2+Y4)+Y3+Y5+Y0,3(Y3+Y5)+Y2+Y4+Y1  ?, P1, ?, Q1
	vrev64.32	q4, q4				// q4 contains P1, ?, Q1, ? 
	vtrn.32		q3, q4				// q3 contains P0,P1,Q0,Q1 
	
	
	
	vmul.u32	q7, q11, q6			// q7 contains 3(X0+X4),3(X1+X5),3(Y0+Y4),3(Y1+Y5)
	vadd.u32	q4, q7, q12			// q4 contains 3(X0+X4)+X3+X5,3(X1+X5)+X2+X4,3(Y0+Y4)+Y3+Y5,3(Y1+Y5)+Y2+Y4
	vadd.u32	q4, q1, q4			// q4 contains 3(X0+X4)+X3+X5+X2,3(X1+X5)+X2+X4+X3,3(Y0+Y4)+Y3+Y5+Y2,3(Y1+Y5)+Y2+Y4+Y3  P2, ?, Q2, ?	 
	vrev64.32	q7, q7				// q7 contains 3(X1+X5),3(X0+X4),3(Y1+Y5),3(Y0+Y4)
	vadd.u32	q7, q7, q11			// q7 contains 3(X1+X5)+X0+X4,3(X0+X4)+X1+X5,3(Y1+Y5)+Y0+Y4,3(Y0+Y4)+Y1+Y5
	vadd.u32	q7, q7, q9			// q7 contains 3(X1+X5)+X0+X4+X3,3(X0+X4)+X1+X5+X2,3(Y1+Y5)+Y0+Y4+Y3,3(Y0+Y4)+Y1+Y5+Y2   P3, ? , Q3, ?
	vtrn.32		q4, q7				// q4 contains P2,P3,Q2,Q3
	
	vmul.u32	q7, q10, q6			// q7 contains 3(X0+X2),3(X1+X3),3(Y0+Y2),3(Y1+Y3)
	vrev64.32	q11, q11			// q11 contains  X1+X5,X0+X4,Y1+Y5,Y0+Y4
	vadd.u32	q11, q11, q2			// q11 contains  X1+X5+X4,X0+X4+X5,Y1+Y5+Y4,Y0+Y4+Y5
	vadd.u32	q5, q7, q11			// q5 contains 3(X0+X2)+X1+X5+X4,3(X1+X3)+X0+X4+X5,3(Y0+Y2)+Y1+Y5+Y4,3(Y1+Y3)+Y0+Y4+Y5  P4, ?, Q4, ?
	vrev64.32	q10, q10			// q10 contains X1+X3,X0+X2,Y1+Y3,Y0+Y2
	vadd.u32	q6, q2, q10			// q6 contains X1+X3+X4,X0+X2+X5,Y1+Y3+Y4,Y0+Y2+Y5
	vadd.u32	q6, q6, q7			// q6 contains 3(X0+X2)+X1+X3+X4,3(X1+X3)+X0+X2+X5,3(Y0+Y2)+Y1+Y3+Y4,3(Y1+Y3)+Y0+Y2+Y5   ?, P5, ?, Q5
	vrev64.32	q6, q6				// q6 contains P5, ? , Q5, ?
	vtrn.32		q5, q6				// q5 contains P4, P5, Q4, Q5
	

	/*
	Now we have these: 
	q0 		X0,X1,Y0,Y1
	q1 		X2,X3,Y2,Y3
	q2 		X4,X5,Y4,Y5
	q3		P0,P1,Q0,Q1
	q4		P2,P3,Q2,Q3
	q5		P4,P5,Q4,Q5
	*/
	
	
	vmull.u32	q3, d6, d7			// q3 contains P0Q0,P1Q1 
	vmull.u32	q4, d8, d9			// q4 contains P2Q2,P3Q3
	vmull.u32	q5, d10, d11			// q5 contains P4Q4,P5Q5
	

	/* Now reduction */
	mov 		r5, #2				// our prime number is 2^26-5 (in form of 2^ell-c)
	lsl		r5, #25				// r5 contains 2^27 or 2^(ell+1)
	sub		r5, r5, #1			// r6 contains 2^ell - 1
	vmov.i32    	q7  , #0
	vmov.i32    	q8  , #0
	
	vmov		s28 , r5						
	vmov		s30, r5
	
	vmov 		q8, q7				// q8: d16, d17 contain 2^ell - 1
					
	vmov.i32	q9, #5
	vshr.u64	q9, #32
	

	/*was P0Q0 d8 P1Q1 d9 --> P0Q0 d6 P1Q1 d7*/
	vand.u64	q10, q8, q3		 	// a0 = a&(2^ell - 1)
	vshr.u64	q3, #26				// a1 = a>>ell
	vmov.i32    	q11  , #0
	vmov.i32    	q12  , #0
	vmlal.u32	q11, d6, d18			// d0*5 = c*a1
	vmlal.u32	q12, d7, d19
	vadd.u64	q3, q11, q10			// c*a1+a0
	vadd.u64	q11, q12, q10
	vmov		d7, d22
		
	
	vand.u64	q10, q8, q3		 	// a0 = a&(2^ell - 1)
	vshr.u64	q3, #26				// a1 = a>>ell
	vmov.i32    	q11  , #0
	vmov.i32    	q12  , #0
	vmlal.u32	q11, d6, d18			// d0*5 = c*a1
	vmlal.u32	q12, d7, d19
	vadd.u64	q3, q11, q10			// c*a1+a0
	vadd.u64	q11, q12, q10
	vmov		d7, d22
	
	/*reduced P0Q0 is in d6, and reduced P1Q1 is in d7 q3*/
	
	
	/*was P2Q2 d10 P3Q3 d11 --> P2Q2 d8 P3Q3 d9*/
	vand.u64	q10, q8, q4			// a0 = a&(2^ell - 1)
	vshr.u64	q4, #26				// a1 = a>>ell
	vmov.i32    	q11  , #0
	vmov.i32    	q12  , #0
	vmlal.u32	q11, d8, d18			// d0*5 = c*a1
	vmlal.u32	q12, d9, d19
	vadd.u64	q4, q11, q10			// c*a1+a0
	vadd.u64	q11, q12, q10
	vmov		d9, d22
		
	
	vand.u64	q10, q8, q4			// a0=a&(2^ell - 1)
	vshr.u64	q4, #26				// a1=a>>ell
	vmov.i32    	q11  , #0
	vmov.i32    	q12  , #0
	vmlal.u32	q11, d8, d18			// d0*5 = c*a1
	vmlal.u32	q12, d9, d19
	vadd.u64	q4, q11, q10			// c*a1+a0
	vadd.u64	q11, q12, q10
	vmov		d9, d22
	
				
	/*reduced P2Q2 is in d8, and reduced P3Q3 is in d9 q4*/
	
	/*was P4Q4 d12 P5Q5 d13 --> P4Q4 d10 P5Q5 d11*/
	vand.u64	q10, q8, q5			// a0 = a&(2^ell - 1)
	vshr.u64	q5, #26				// a1 = d6>>ell=a>>ell
	vmov.i32    	q11  , #0
	vmov.i32    	q12  , #0
	vmlal.u32	q11, d10, d18			// d0*5 = c*a1
	vmlal.u32	q12, d11, d19
	vadd.u64	q5, q11, q10			// c*a1+a0
	vadd.u64	q11, q12, q10
	vmov		d11, d22
		
	
	vand.u64	q10, q8, q5			// a0 = a&(2^ell - 1)
	vshr.u64	q5, #26				// a1 = a>>ell
	vmov.i32    	q11  , #0
	vmov.i32    	q12  , #0
	vmlal.u32	q11, d10, d18			// d0*5 = c*a1
	vmlal.u32	q12, d11, d19
	vadd.u64	q5, q11, q10			// c*a1+a0
	vadd.u64	q11, q12, q10
	vmov		d11, d22
				
	/*reduced P4Q4 is in d10, and reduced P5Q5 is in d11 q5*/
	
	/*
	Now we have these: 
	q0 		X0,X1,Y0,Y1
	q1 		X2,X3,Y2,Y3
	q2 		X4,X5,Y4,Y5
	q3   reduced  	P0Q0,P1Q1
	q4   reduced	P2Q2,P3Q3
	q5   reduced	P4Q4,P5Q5
	*/
	
	
	vmull.u32	q0, d0, d1		  	// q0 contains X0Y0,X1Y1 
	vmull.u32	q1, d2, d3			// q1 contains X2Y2,X3Y3
	vmull.u32	q2, d4, d5			// q2 contains X4Y4,X5Y5
	
	
	
	/*X0Y0 d0 X1Y1 d1*/
	vand.u64	q10, q8, q0		 	// a0 = a&(2^ell - 1)
	vshr.u64	q0, #26						// a1 = d6>>ell=a>>ell
	vmov.i32    	q11  , #0
	vmov.i32    	q12  , #0
	vmlal.u32	q11, d0, d18			// d0*5 = c*a1
	vmlal.u32	q12, d1, d19
	vadd.u64	q0, q11, q10			// c*a1+a0
	vadd.u64	q11, q12, q10
	vmov		d1, d22
		
		
	vand.u64	q10, q8, q0			// a0 = a&(2^ell - 1)
	vshr.u64	q0, #26						// a1 = d6>>ell=a>>ell
	vmov.i32    	q11  , #0
	vmov.i32    	q12  , #0
	vmlal.u32	q11, d0, d18			// d0*5 = c*a1
	vmlal.u32	q12, d1, d19
	vadd.u64	q0, q11, q10			// c*a1+a0
	vadd.u64	q11, q12, q10
	vmov		d1, d22
	
	/*reduced X0Y0 is in d0, and reduced X1Y1 is in d1 q0*/
	
	/*X2Y2 d2 X3Y3 d3*/
	vand.u64	q10, q8, q1 			// a0 = a&(2^ell - 1)
	vshr.u64	q1, #26				// a1 = d6>>ell=a>>ell
	vmov.i32    	q11  , #0
	vmov.i32    	q12  , #0
	vmlal.u32	q11, d2, d18			// d0*5 = c*a1
	vmlal.u32	q12, d3, d19
	vadd.u64	q1, q11, q10			// c*a1+a0
	vadd.u64	q11, q12, q10
	vmov		d3, d22
	
	
	vand.u64	q10, q8, q1 			// a0 = a&(2^ell - 1)
	vshr.u64	q1, #26				// a1 = d6>>ell=a>>ell
	vmov.i32    	q11  , #0
	vmov.i32    	q12  , #0
	vmlal.u32	q11, d2, d18			// d0*5 = c*a1
	vmlal.u32	q12, d3, d19
	vadd.u64	q1, q11, q10			// c*a1+a0
	vadd.u64	q11, q12, q10
	vmov		d3, d22
	

	/*reduced X2Y2 is in d2, and reduced X3Y3 is in d3 q1*/
	
	/*X4Y4 d4 X5Y5 d5*/	
	vand.u64	q10, q8, q2			// a0 = a&(2^ell - 1)
	vshr.u64	q2, #26				// a1 = d6>>ell=a>>ell
	vmov.i32    	q11  , #0
	vmov.i32    	q12  , #0
	vmlal.u32	q11, d4, d18			// d0*5 = c*a1
	vmlal.u32	q12, d5, d19
	vadd.u64	q2, q11, q10			// c*a1+a0
	vadd.u64	q11, q12, q10
	vmov		d5, d22
	
	
	vand.u64	q10, q8, q2			// a0 = a&(2^ell - 1)
	vshr.u64	q2, #26				// a1 = d6>>ell=a>>ell
	vmov.i32    	q11  , #0
	vmov.i32    	q12  , #0
	vmlal.u32	q11, d4, d18			// d0*5 = c*a1
	vmlal.u32	q12, d5, d19
	vadd.u64	q2, q11, q10			// c*a1+a0
	vadd.u64	q11, q12, q10
	vmov		d5, d22
	
	/*reduced X4Y4 is in d4, and reduced X5Y5 is in d5 q2*/
	
	/*
	Now we have these: 
	q3		reduced  	P0Q0,P1Q1
	q4		reduced		P2Q2,P3Q3
	q5		reduced		P4Q4,P5Q5
	q0		reduced		X0Y0,X1Y1	
	q1		reduced		X2Y2,X3Y3
	q2		reduced		X4Y4,X5Y5
	*/
	
	vmov 	s1,s2
	vmov	s2,s4
	vmov	s3,s6
	vmov	s4,s8			// Now q0: X0Y0, X1Y1, X2Y2, X3Y3
	vmov	s5,s10    
	vmov	s6,s12
	vmov	s7,s14
	vmov	s8,s16
	vmov	s9,s18
	vmov	s10,s20
	vmov	s11,s22
	
	
	sub		r1, r1, #48
	vld1.32		{q7,q8}, [r1]!			
	vld1.32 	{q9}, [r1]!
	
	vadd.u32	q0, q0, q7
	vadd.u32	q1, q1, q8
	vadd.u32	q2, q2, q9	


	/* Now Reduction */
	vmov.i32	q7, #2
	vshl.u32	q7, #25
	vmov.i32	q8, #1
	vsub.u32	q8,q7,q8
	vmov.i32	q9, #5
	
	
	/*X0Y0, X1Y1, X2Y2, X3Y3 in q0*/
	vand.u32	q10, q8, q0		 	// a0 = a&(2^ell - 1)
	vshr.u32	q0, #26				// a1 = a>>ell
	vmov.i32    	q11  , #0
	vmla.u32	q11, q0, q9			// c*a1
	vadd.u32	q0, q11, q10			// c*a1+a0
	
		
	/*X4Y4, X5Y5, P0Q0, P1Q1 in q1*/
	vand.u32	q10, q8, q1		 	// a0 = a&(2^ell - 1)
	vshr.u32	q1, #26				// a1 = a>>ell
	vmov.i32    	q11  , #0
	vmla.u32	q11, q1, q9			// c*a1
	vadd.u32	q1, q11, q10			// c*a1+a0
	
		
	/*P2Q2, P3Q3, P4Q4, P5Q5 in q2*/
	vand.u32	q10, q8, q2		 	// a0 = a&(2^ell - 1)
	vshr.u32	q2, #26				// a1 = a>>ell
	vmov.i32    	q11  , #0
	vmla.u32	q11, q2, q9			// c*a1
	vadd.u32	q2, q11, q10			// c*a1+a0
			
	vst1.8		{q0,q1}, [r1]!
	vst1.8		{q2}, [r1]!	
	
	subs		r2, r2, #36
	bcs     	.Lloop3
	
.Lloop3_done:
	bx		lr

.align 8
