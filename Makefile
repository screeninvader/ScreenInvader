TARGET := $(shell git log -1 --pretty=%H).dd
ARCH := armhf
CACHER_PORT := 3142
OPTS := -x
FS_DIR := armhf-fs
IMAGE_SIZE := 4000
MKIMG_OPTS := -u -z

.PHONY: all image release debug

all: release

screeninvader.dd.tmp:
	./makeimage.sh -s ${IMAGE_SIZE} ${MKIMG_OPTS} screeninvader.dd.tmp

debug: ARCH := amd64
debug: OPTS += -k
debug: FS_DIR := amd64-fs
debug: MKIMG_OPTS := -x -z
debug: ${TARGET}

release: ${TARGET}

${FS_DIR}:
	./bootstrap.sh -a ${ARCH} -p ${CACHER_PORT} ${OPTS} ${FS_DIR}
	
${TARGET}: screeninvader.dd.tmp ${FS_DIR}
	./mountimage.sh screeninvader.dd.tmp tmp
	cp -a ${FS_DIR}/boot/* tmp/p1/
	cp -a ${FS_DIR}/* tmp/p2/
	./umountimage.sh screeninvader.dd.tmp tmp
	mv screeninvader.dd.tmp ${TARGET}
	tar -cjf ${TARGET}-${ARCH}.tar.bz2 ${TARGET}

clean:
	rm -f screeninvader.dd.tmp
	rm -f screeninvader.dd
	rm -f ${TARGET}-${ARCH}.tar.bz2
	rm -fr amd64-fs
	rm -fr armhf-fs


