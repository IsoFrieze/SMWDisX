ASAR = ./asar
SHA1SUM = sha1sum

# must be in sync with constants.asm
version_id_jp  := 0
version_id_us  := 1
version_id_nss := 2
version_id_eu0 := 3
version_id_eu1 := 4

roms := $(patsubst %,smw-%.smc,jp us nss eu0 eu1)
roms_headerless :=  ${roms:%.smc=%.sfc}

check :: all-headerless
	${SHA1SUM} --check rom-sha1sums.txt

all :: ${roms}

all-headerless :: ${roms_headerless}

clean ::
	${RM} ${roms} ${roms_headerless}

smw-%.smc: smw.asm
	${ASAR} -D_VER=${version_id_$*} $< $@

%.sfc: %.smc
	cmp --bytes=512 $< /dev/zero
	tail -c +513 $< >$@


.DELETE_ON_ERROR:


# dependencies
lvl_jp := $(wildcard lvl/*/*_J.bin)
lvl_nss := $(wildcard lvl/*/*_SS.bin)
lvl_not_jp := ${lvl_jp:%_J.bin=%_U.bin}
lvl_not_nss := ${lvl_ss:%_SS.bin=%_U.bin}
lvl_common := $(filter-out ${lvl_jp} ${lvl_not_jp} ${lvl_nss} ${lvl_not_nss},$(wildcard lvl/*/*.bin))

${roms}: *.asm sfx/*.bin samples/*.brr
smw-jp.smc:  gfx/j/*.bin ${lvl_common} ${lvl_jp} ${lvl_not_nss}
smw-us.smc:  gfx/u/*.bin ${lvl_common} ${lvl_not_jp} ${lvl_not_nss}
smw-nss.smc: gfx/u/*.bin ${lvl_common} ${lvl_not_jp} ${lvl_nss}
smw-eu0.smc: gfx/u/*.bin ${lvl_common} ${lvl_not_jp} ${lvl_not_nss}
smw-eu1.smc: gfx/e/*.bin ${lvl_common} ${lvl_not_jp} ${lvl_not_nss}
