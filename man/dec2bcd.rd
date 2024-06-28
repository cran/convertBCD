\name{dec2bcd}
\alias{dec2bcd}
\title{
Convert decimal numbers to binary-coded decimal (BCD) form.  ~~
  ~~
}
\description{
The input decimal values are converted to one or two vectors of class "raw" , representing an integer and optionally a decimal portion of a number.  
}
\usage{
dec2bcd(x, endian = c("little", "big"))
}
\arguments{
   \item{x}{
Decimal numbers. Can be one of the following classes: numeric, bigz, character. 
}
  \item{endian}{
The order of bytes desired in the raw BCD output.  
}

}
\details{
The BCD format reserves a full byte for each character (number) in an input value. While this is memory-expensive, it guarantees the exact value is stored, unlike class \code{numeric} or others, which are subject to binary expansion rounding errors.  
There is no standard for indicating the location of a decimal point in BCD data, which is why the integer and decimal portion are returned separately. .
}
\value{
A list containing:
intx , a vector of strings representing the integer parts of the decimal number
decx, a vector  of strings representing the decimal parts of the decimal number, if any.  
}

\seealso{
\code{\link[oce]{bcdToInteger} }, \code{\link{bcd2dec}}

}
\examples{
foo <- dec2bcd('37.852')
bar <- bcd2dec(foo$xint[[1]],foo$xdec[[1]])

}
 
\author{
Carl Witthoft,  \email{carl@witthoft.com} 
}
