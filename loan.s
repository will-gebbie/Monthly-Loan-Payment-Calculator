
*----------------------------------------------------------------------
*
        ORG     $0
        DC.L    $3000           * Stack pointer value after a reset
        DC.L    start           * Program counter value after a reset
        ORG     $3000           * Start at location 3000 Hex
*
*----------------------------------------------------------------------
* 	Imported Macros 
#minclude /home/cs/faculty/riggins/bsvc/macros/iomacs.s
#minclude /home/cs/faculty/riggins/bsvc/macros/evtmacs.s
*
*----------------------------------------------------------------------
*
* Register use
*
*----------------------------------------------------------------------
*
start:  initIO                  * Initialize (required for I/O)
	setEVT			* Error handling routines
	initF			* For floating point macros only	


	lineout         title   * Your code goes HERE
    lineout         skipln
    lineout         prompt1
    floatin         buffer 		
    cvtaf           buffer,D1 	*stores loan amount in D1
    lineout         prompt2
    floatin         buffer
    cvtaf           buffer,D2 	*stores interest rate in D2
	move.l 			#$4B0,D3 	*stores 1200 into D3
	itof 			D3,D3 		*converts 1200 into float
	fdiv 			D3,D2		*converts annual into monthly
    lineout         prompt3
    floatin         buffer
    cvtaf           buffer,D3 	*stores length(months) in D3
    lineout         skipln 	
	
	move.b 		#$1,D5 		*stores 1 into D5
	itof 		D5,D5 		*converts 1 into float number 
	move.l 		D2,D4 		*copy interest rate into D4
	fadd 		D5,D4		*stores 1+interest rate into D4
	
	fpow 		D4,D3 		
	move.l 		D0,D4 		*stores (1+rate)^months in D4
	
	
	move.l 		D4,D6 		*allow D6 to be numerator
	fmul 		D2,D6 		*stores r(1+r)^n into D6
	fmul 		D1,D6 		*stores P*r(1+r)^n into D6
	
	*NUMERATOR stored in D6
	
	move.l 		D4,D7 		*copies (1+r)^n into D7
	fsub 		D5,D7 		*subtracts 1 from D7
	
	*DENOMINATOR stored in D7
	
	fdiv 		D7,D6 		*answer stored into D6
	
	*FORMAT ANSWER
	
	move.l 		D6,D0
	cvtfa 		buffer,#2

        lineout         answer	
		

        break                   * Terminate execution
*
*----------------------------------------------------------------------
*       Storage declarations
                        * Your storage declarations go HERE

title:  dc.b    'Program #2, Will Gebbie, cssc0200',0
skipln: dc.b    0,0
prompt1: dc.b   'Enter the amount of the loan: ',0
prompt2: dc.b   'Enter the annual percentage rate: ',0
prompt3: dc.b   'Enter the length of the loan in months: ',0
answer: dc.b    'Your monthly payment will be $'	
buffer: ds.b    82


        end
