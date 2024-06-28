# convert numbers into BCD 
# here is the code from oce lib which converts the other way
# # bcdToInteger <- function (x, endian = c("little", "big")) 
# {
    # endian <- match.arg(endian)
    # x <- as.integer(x)
    # byte1 <- as.integer(floor(x/16))
    # byte2 <- x - 16 * byte1
    # if (endian == "little") 
        # 10 * byte1 + byte2
    # else byte1 + 10 * byte2
# }
# so, I'll just fancy-up the oce version.
# TODO: 
# 2) consider invoking biq, bigz to handle absurdly large inputs
# 1) DUN some wrapper to take one vector as integer , the other as decimal, and combine
# the two. 
bcd2dec <- function (x, xdec = NULL, mergex = TRUE, endian = c("little", "big")) {
    endian <- match.arg(endian)
    if (!is.raw(x)) stop('input must be raw')
    x <- as.integer(x)
    byte1 <- as.integer(floor(x/16))
    byte2 <- x - 16 * byte1   
    if (endian == "little") 
       intout <-  10 * byte1 + byte2
    	else  intout <- byte1 + 10 * byte2
# ya know what? Always convert to a single actual number
#    if(mergex) intout <- sum(intout * 10^(seq(2*length(intout) -2 , 0, by= -2 )) )
    intout <- sum(gmp::as.bigz(intout) * 10^(seq(2*length(intout) -2 , 0, by= -2 )) )
# to preserve the decimal portion in an eye-pleasing way, switch to char
	intout <- paste0(as.character(intout), collapse= '')
    if(!is.null(xdec)) {
    	 xdec <- as.integer(xdec)
	    byte1 <- as.integer(floor(xdec/16))
	    byte2 <- xdec - 16 * byte1	    
	    if (endian == "little") 
	       decout <-  10 * byte1 + byte2
	   	 else  decout <- byte1 + 10 * byte2
	# watch those powers!
#	    decout <- sum(decout * 10^(-seq(2,2*length(decout)  , by= 2 )) )
#	    decout <- sum(as.bigq (decout , 10^(seq(2,2*length(decout)  , by= 2 )) ) )
#  Since output is going to be char, just calculate like the integer part and add
# the decimal
		decout <- sum(gmp::as.bigz(decout) * 10^(seq(2*length(decout) -2 , 0, by= -2 )) )
		decx <- paste0('.',decout,collapse='')
    } else decx <- '.0'
# browser()
# funky stuff when not merged like proper folks do
	if(mergex) {
		intout <- paste0(intout , decx, collapse= '')
		decx <- NULL
	}  
 return(list(intx = intout,decx = decx))
}


dec2bcd <- function(x, endian = c("little", "big")) {
# input processing for all classes.  Don't allow bigq 
if (!class(x[[1]]) %in% c('bigz','mpfr','numeric','character')) stop(c("Unsupported input class" , class(x[[1]]) ) )
if(is(x[[1]], 'mpfr') ) {
	x <- as.character(Rmpfr::formatDec(x))
	x <- gsub(' ','',x)
}
if(is(x[[1]],'bigz') || is(x[[1]],'numeric')) x <- as.character(x)
#casting to char is exact, up to 15 +/-  digits. 
endian <- match.arg(endian)
#  pick the decimal point character based on Sys.localeconv()[1]	
thedec <- Sys.localeconv()[1]
# clean up signs
for (jn in 1:length(x)) {
		x[[jn]] <- gsub('^-','',x[[jn]])
				x[[jn]] <- gsub('^+','',x[[jn]])
	}	
# split parts
# problem: this xdec gsub won't remove a pure integer. added a fix
xint <- gsub(paste0('[',thedec,'].{0,}$') ,'',x)
#		xint <- gsub('[.].{0,}$','',x)
xdec <- gsub(paste0('^.{0,}[',thedec,']'),'',x )
#		xdec <- gsub('^.{0,}[.]' ,'', x)
xdec[xdec == x] <- '00'
# First, determine seq order. stupid magic numbers
frist <- 1
sceond <- 2
# set up lists
xint <- as.list(xint)
xdec <- as.list(xdec)
#  browser()
for (ji in 1:length(x)) {
	 foon <- nchar(xint[[ji]])
# catch empties
	if (foon == 0) { xint[[ji]] <- '00' ; foon =2}
 if (foon%%2) { 
 	xint[[ji]] <- paste0('0',xint[[ji]],collapse='') 
 	 foon <- nchar(xint[[ji]]) 
 	 }
	 bar <- substring(xint[[ji]],seq(frist,foon,by=2), seq(sceond,foon, by = 2)  )
# browser()
	if(endian == 'big'){
		bar  <- sapply(lapply(strsplit(bar, NULL), rev), paste, collapse="")	
	}
	 barx <- paste0('0x',bar)
 # now we have pairs, just do as.raw() 
	xint[[ji]] <- as.raw(barx)
} #end of ji loop
for (ji in 1:length(x)) {
	foon <- nchar(xdec[[ji]])
	if (foon == 0) { xdec[[ji]] <- '00'  ; foon =2 }
	if (foon%%2) {
		xdec[[ji]] <- paste0(xdec[[ji]],'0',collapse='') 
		foon <- nchar(xdec[[ji]]) 
	}
	bar <- substring(xdec[[ji]],seq(frist,foon,by=2), seq(sceond,foon, by = 2)  )
	if(endian == 'big'){
		bar  <- sapply(lapply(strsplit(bar, NULL), rev), paste, collapse="")
	}
	barx <- paste0('0x',bar)
	xdec[[ji]] <- as.raw(barx)
} #end of 2nd ji loop

# return as two lists so that c(int[[j]] , dec[[j]] ) is the full bcd for x[j] 	
return(list(xint = xint, xdec = xdec))
}
