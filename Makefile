CXX=g++
CXXFLAGS=-std=c++14 -I./src/cutf -I./src/cxxopts/include -O3
OMPFLAGS=-fopenmp
NVCC=nvcc
NVCCFLAGS=$(CXXFLAGS)  --compiler-bindir=$(CXX) -Xcompiler=$(OMPFLAGS) -lcublas -arch=sm_30 -lnvidia-ml
SRCDIR=src
SRCS=$(shell find $(SRCDIR) -maxdepth 1 -name '*.cu' -o -name '*.cpp')
OBJDIR=objs
OBJS=$(subst $(SRCDIR),$(OBJDIR), $(SRCS))
OBJS:=$(subst .cpp,.o,$(OBJS))
OBJS:=$(subst .cu,.o,$(OBJS))
TARGET=atsukan

$(TARGET): $(OBJS)
	$(NVCC) $(NVCCFLAGS) $+ -o $@

$(SRCDIR)/%.cpp: $(SRCDIR)/%.cu
	$(NVCC) $(NVCCFLAGS) --cuda $< -o $@

$(OBJDIR)/%.o: $(SRCDIR)/%.cpp
	[ -d $(OBJDIR) ] || mkdir $(OBJDIR)
	$(CXX) $(CXXFLAGS) $(OMPFLAGS) $< -c -o $@


clean:
	rm -rf $(OBJS)
	rm -rf $(TARGET)

