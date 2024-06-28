\name{bcd2dec}
\alias{bcd2dec}
\title{
Function to convert binary-coded decimal (BCD) data to decimal form.  ~~
}
\description{
Given one or two input vectors of class "raw" , representing an integer and optionally a decimal portion of a number, the  decimal values are returned.      
}
\usage{
bcd2dec(x, xdec = NULL, mergex = TRUE, endian = c("little", "big"))
}
\arguments{
   \item{x}{
The vector of bytes containing the BCD representation of the integer portion of a value. Must be of class 'raw'.  
}
  \item{xdec}{
The vector of bytes containing the BCD representation of the decimal portion of a value  Must be of class 'raw'. The default is \code{NULL}.
}
\item{mergex}{
A logical value.  If \code{TRUE}, The integer and decimal parts are combined to return a single number.  Otherwise the integer and decimal parts are returned separately. 
}
  \item{endian}{
The order of bytes  in the raw BCD input.  
}
 }

\details{
The BCD format reserves a full byte for each character (number) in an input value. While this is memory-expensive, it guarantees the exact value is stored, unlike class \code{numeric} or others, which are subject to binary expansion rounding errors.  
There is no standard for indicating the location of a decimal point in BCD data, which is why the integer and decimal portion must be entered separately here. 
}
\value{
A list with elements: 
intx , character strings representing the decimal numbers produced or, if \code{mergex == FALSE}, the integer portions of the numbers.
decx , set to NULL unless \code{mergex == FALSE}, in which case character strings representing the decimal portions of the numbers generated. 
 
}

\seealso{
\code{\link[oce]{bcdToInteger} } \code{dec2bcd}
}
\examples{
foo <- dec2bcd('37.852')
bar <- bcd2dec(foo$xint[[1]],foo$xdec[[1]])
}
 
\author{
Carl Witthoft,  \email{carl@witthoft.com} 
}
