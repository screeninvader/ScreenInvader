TARGET := $(shell git log -1 --pretty=%H).dd
ARCH := armhf
CACHER_PORT := 3142
OPTS := -x
FS_DIR := armhf-fs
IMAGE_SIZE := 4000
MKIMG_OPTS := -u -z

.PHONY: all image release debug deploy clean test-release test-debug

all: release

screeninvader.dd.tmp:
	./makeimage.sh -s ${IMAGE_SIZE} ${MKIMG_OPTS} screeninvader.dd.tmp

makedefaultconf:
	cp src/setup/template-firstboot.cnf src/setup/answer.sh

debug: ARCH := amd64
debug: OPTS += -k
debug: FS_DIR := amd64-fs
debug: MKIMG_OPTS := -x -z
debug: TARGET := ${TARGET}-${ARCH}
debug: makedefaultconf ${TARGET}

release: TARGET := ${TARGET}-${ARCH}
release: OPTS += -k
release: ${TARGET}

${FS_DIR}:
	./bootstrap.sh -c config/answer.sh -a ${ARCH} ${OPTS} ${FS_DIR}
	
${TARGET}: screeninvader.dd.tmp ${FS_DIR}
	./mountimage.sh screeninvader.dd.tmp tmp
	cp -a ${FS_DIR}/boot/* tmp/p1/
	cp -a ${FS_DIR}/* tmp/p2/
	./umountimage.sh screeninvader.dd.tmp tmp
	mv screeninvader.dd.tmp ${TARGET}
	tar -cjf ${TARGET}.tar.bz2 ${TARGET}

clean:
	rm -f screeninvader.dd.tmp
	rm -f *.dd-amd64
	rm -f *.dd-armhf
	rm -f *.dd-*.tar.bz2
	rm -fr amd64-fs
	rm -fr armhf-fs
	rm -f src/setup/answer.sh

test-debug:
	./test.sh amd64 ${TARGET}-amd64

test-release: 
	./test.sh armhf ${TARGET}-armhf

