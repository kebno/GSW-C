# J. Boyle, Sep 2017, Added static library creation, used implicit rules and default Make variables
#
#  $Id: Makefile,v 1e5e75c749c2 2015/08/08 22:03:51 fdelahoyde $
#
CFLAGS_OPTIMIZE ?= -Ofast -ffast-math
CFLAGS +=	${CFLAGS_OPTIMIZE} -Wall -Wextra -Wpointer-arith -Wshadow -std=gnu99
TARGET_ARCH ?= -march=native

LDFLAGS :=	-L.
LDLIBS :=	-lm -lgswteos-10

LIB_SRCS :=	gsw_oceanographic_toolbox.c gsw_saar.c
LIB_OBJS :=	gsw_oceanographic_toolbox.o gsw_saar.o

ARFLAGS :=	rsvu



all:	libs gsw_check_functions

libs: libgswteos-10.so libgswteos-10.a

gsw_check_functions : gsw_check_functions.c -lgswteos-10

# ":=" 	Simply defined variable assignment operator. The value of a "simply expanded variable" is scanned once and for all when the variable is defined, immediately expanding any references to other variables and functions.
# "?=" 	This is called a conditional variable assignment operator, because it only has an effect if the variable is not yet defined
# The special Make variables $@ and $^ represent the rule target, and the rule prerequisites (everything to the right of the colon in a rule), respectively

# Use the implicit rule for static libraries ("archives" as called in Make docs)
libgswteos-10.a : libgswteos-10.a(${LIB_OBJS})

# Use target specific rules
libgswteos-10.so : ${LIB_SRCS}
	${CC} -shared -fPIC ${CFLAGS} ${TARGET_ARCH} $^ -o $@

clean:
	rm -f gsw_check_functions libgswteos-10.a libgswteos-10.so

.PHONY : all clean libs
