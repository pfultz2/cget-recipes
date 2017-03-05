cmake_minimum_required(VERSION 2.8)

function(patch_file FILE MATCH REPLACEMENT)
    message(STATUS "Patch: ${FILE}")
    file(READ ${FILE} CONTENT)
    string(REPLACE 
        "${MATCH}"
        "${REPLACEMENT}" 
        OUTPUT_CONTENT "${CONTENT}")
    file(WRITE ${FILE} "${OUTPUT_CONTENT}")
endfunction()

project(nettle)
set(PACKAGE_VERSION 3.3)
set(MAJOR_VERSION 3)
set(MINOR_VERSION 3)
set(NETTLE_USE_MINI_GMP 1)

include ( CheckFunctionExists )
include ( CheckIncludeFiles )
include ( CheckTypeSize )

# check_function_exists(__attribute HAVE_GCC_ATTRIBUTE)
# HAVE_LIBDL
# HAVE_LIBGMP
# HAVE_LINK_IFUNC

set(CONFIG_VARS)
macro(set_config VAR)
    set(${VAR} ${ARGN})
    list(APPEND CONFIG_VARS ${VAR})
endmacro()
macro(nettle_check_include_files INCLUDE VAR)
    check_include_files(${INCLUDE} ${VAR})
    list(APPEND CONFIG_VARS ${VAR})
endmacro()

macro(nettle_check_function_exists FUNC VAR)
    check_function_exists(${FUNC} ${VAR})
    list(APPEND CONFIG_VARS ${VAR})
endmacro()

nettle_check_include_files(alloca.h HAVE_ALLOCA_H)
nettle_check_include_files(dlfcn.h HAVE_DLFCN_H)
nettle_check_include_files(inttypes.h HAVE_INTTYPES_H)
nettle_check_include_files(malloc.h HAVE_MALLOC_H)
nettle_check_include_files(memory.h HAVE_MEMORY_H)
nettle_check_include_files(openssl/aes.h HAVE_OPENSSL_AES_H)
nettle_check_include_files(openssl/blowfish.h HAVE_OPENSSL_BLOWFISH_H)
nettle_check_include_files(openssl/cast.h HAVE_OPENSSL_CAST_H)
nettle_check_include_files(openssl/des.h HAVE_OPENSSL_DES_H)
nettle_check_include_files(openssl/ecdsa.h HAVE_OPENSSL_ECDSA_H)
nettle_check_include_files(stdint.h HAVE_STDINT_H)
nettle_check_include_files(stdlib.h HAVE_STDLIB_H)
nettle_check_include_files(strings.h HAVE_STRINGS_H)
nettle_check_include_files(string.h HAVE_STRING_H)
nettle_check_include_files(sys/stat.h HAVE_SYS_STAT_H)
nettle_check_include_files(sys/types.h HAVE_SYS_TYPES_H)
nettle_check_include_files(unistd.h HAVE_UNISTD_H)
nettle_check_include_files(valgrind/memcheck.h HAVE_VALGRIND_MEMCHECK_H)

nettle_check_function_exists(alloca HAVE_ALLOCA)
nettle_check_function_exists(fcntl HAVE_FCNTL_LOCKING)
nettle_check_function_exists(clock_gettime HAVE_CLOCK_GETTIME)
nettle_check_function_exists(getline HAVE_GETLINE)
nettle_check_function_exists(secure_getenv HAVE_SECURE_GETENV)
nettle_check_function_exists(strerror HAVE_STRERROR)

check_type_size("char" SIZEOF_CHAR)
check_type_size("int" SIZEOF_INT)
check_type_size("long" SIZEOF_LONG)
check_type_size("short" SIZEOF_SHORT)
check_type_size("size_t" SIZEOF_SIZE_T)
check_type_size("void*" SIZEOF_VOIDP)

set_config(STDC_HEADERS On)
set_config(WITH_HOGWEED On)
set_config(WITH_OPENSSL On)

set(CHAR_BITS 8) # Always assume 8 bits for char
set(GMP_NUMB_BITS "${SIZEOF_LONG} * ${CHAR_BITS}")

patch_file(config.h.in "#undef" "#cmakedefine")
foreach(VAR ${CONFIG_VARS})
    if(${VAR})
        patch_file(config.h.in "#cmakedefine ${VAR}" "#define ${VAR} 1")
    endif()
endforeach()

foreach(VAR SIZEOF_CHAR SIZEOF_INT SIZEOF_LONG SIZEOF_SHORT SIZEOF_SIZE_T SIZEOF_VOIDP PACKAGE_VERSION MAJOR_VERSION MINOR_VERSION)
    patch_file(config.h.in "#cmakedefine ${VAR}" "#define ${VAR} @${VAR}@")
endforeach()
configure_file(config.h.in ${CMAKE_BINARY_DIR}/config.h)
# file(READ ${CMAKE_BINARY_DIR}/config.h CONTENT)
# message("${CONTENT}")

configure_file(version.h.in ${CMAKE_BINARY_DIR}/version.h @ONLY)
# file(READ ${CMAKE_BINARY_DIR}/version.h CONTENT)
# message("${CONTENT}")

file(WRITE ${CMAKE_BINARY_DIR}/nettle-stdint.h "
#include <stdint.h>
")

add_definitions(-DUNUSED=)
add_definitions(-DHAVE_CONFIG_H=1)
include_directories(.)
include_directories(${CMAKE_BINARY_DIR})
set(getopt_SOURCES getopt.c getopt1.c)
set(internal_SOURCES nettle-internal.c)
set(nettle_SOURCES aes-decrypt-internal.c aes-decrypt.c
         aes-encrypt-internal.c aes-encrypt.c aes-encrypt-table.c
         aes-invert-internal.c aes-set-key-internal.c
         aes-set-encrypt-key.c aes-set-decrypt-key.c
         aes128-set-encrypt-key.c aes128-set-decrypt-key.c
         aes128-meta.c
         aes192-set-encrypt-key.c aes192-set-decrypt-key.c
         aes192-meta.c
         aes256-set-encrypt-key.c aes256-set-decrypt-key.c
         aes256-meta.c
         arcfour.c arcfour-crypt.c
         arctwo.c arctwo-meta.c blowfish.c
         base16-encode.c base16-decode.c base16-meta.c
         base64-encode.c base64-decode.c base64-meta.c
         base64url-encode.c base64url-decode.c base64url-meta.c
         buffer.c buffer-init.c
         camellia-crypt-internal.c camellia-table.c
         camellia-absorb.c camellia-invert-key.c
         camellia128-set-encrypt-key.c camellia128-crypt.c
         camellia128-set-decrypt-key.c
         camellia128-meta.c
         camellia192-meta.c
         camellia256-set-encrypt-key.c camellia256-crypt.c
         camellia256-set-decrypt-key.c
         camellia256-meta.c
         cast128.c cast128-meta.c cbc.c
         ccm.c ccm-aes128.c ccm-aes192.c ccm-aes256.c
         chacha-crypt.c chacha-core-internal.c
         chacha-poly1305.c chacha-poly1305-meta.c
         chacha-set-key.c chacha-set-nonce.c
         ctr.c des.c des3.c des-compat.c
         eax.c eax-aes128.c eax-aes128-meta.c
         gcm.c gcm-aes.c
         gcm-aes128.c gcm-aes128-meta.c
         gcm-aes192.c gcm-aes192-meta.c
         gcm-aes256.c gcm-aes256-meta.c
         gcm-camellia128.c gcm-camellia128-meta.c
         gcm-camellia256.c gcm-camellia256-meta.c
         gosthash94.c gosthash94-meta.c
         hmac.c hmac-md5.c hmac-ripemd160.c hmac-sha1.c
         hmac-sha224.c hmac-sha256.c hmac-sha384.c hmac-sha512.c
         knuth-lfib.c
         md2.c md2-meta.c md4.c md4-meta.c
         md5.c md5-compress.c md5-compat.c md5-meta.c
         memeql-sec.c memxor.c memxor3.c
         nettle-meta-aeads.c nettle-meta-armors.c
         nettle-meta-ciphers.c nettle-meta-hashes.c
         pbkdf2.c pbkdf2-hmac-sha1.c pbkdf2-hmac-sha256.c
         poly1305-aes.c poly1305-internal.c
         realloc.c
         ripemd160.c ripemd160-compress.c ripemd160-meta.c
         salsa20-core-internal.c
         salsa20-crypt.c salsa20r12-crypt.c salsa20-set-key.c
         salsa20-set-nonce.c
         salsa20-128-set-key.c salsa20-256-set-key.c
         sha1.c sha1-compress.c sha1-meta.c
         sha256.c sha256-compress.c sha224-meta.c sha256-meta.c
         sha512.c sha512-compress.c sha384-meta.c sha512-meta.c
         sha512-224-meta.c sha512-256-meta.c
         sha3.c sha3-permute.c
         sha3-224.c sha3-224-meta.c sha3-256.c sha3-256-meta.c
         sha3-384.c sha3-384-meta.c sha3-512.c sha3-512-meta.c
         serpent-set-key.c serpent-encrypt.c serpent-decrypt.c
         serpent-meta.c
         twofish.c twofish-meta.c
         umac-nh.c umac-nh-n.c umac-l2.c umac-l3.c
         umac-poly64.c umac-poly128.c umac-set-key.c
         umac32.c umac64.c umac96.c umac128.c
         version.c
         write-be32.c write-le32.c write-le64.c
         yarrow256.c yarrow_key_event.c)

set(hogweed_SOURCES sexp.c sexp-format.c
          sexp-transport.c sexp-transport-format.c
          bignum.c bignum-random.c bignum-random-prime.c
          sexp2bignum.c
          pkcs1.c pkcs1-encrypt.c pkcs1-decrypt.c
          pkcs1-rsa-digest.c pkcs1-rsa-md5.c pkcs1-rsa-sha1.c
          pkcs1-rsa-sha256.c pkcs1-rsa-sha512.c
          rsa.c rsa-sign.c rsa-sign-tr.c rsa-verify.c
          rsa-pkcs1-sign.c rsa-pkcs1-sign-tr.c rsa-pkcs1-verify.c
          rsa-md5-sign.c rsa-md5-sign-tr.c rsa-md5-verify.c
          rsa-sha1-sign.c rsa-sha1-sign-tr.c rsa-sha1-verify.c
          rsa-sha256-sign.c rsa-sha256-sign-tr.c rsa-sha256-verify.c
          rsa-sha512-sign.c rsa-sha512-sign-tr.c rsa-sha512-verify.c
          rsa-encrypt.c rsa-decrypt.c rsa-decrypt-tr.c
          rsa-keygen.c rsa-blind.c
          rsa2sexp.c sexp2rsa.c
          dsa.c dsa-compat.c dsa-compat-keygen.c dsa-gen-params.c
          dsa-sign.c dsa-verify.c dsa-keygen.c dsa-hash.c
          dsa-sha1-sign.c dsa-sha1-verify.c
          dsa-sha256-sign.c dsa-sha256-verify.c 
          dsa2sexp.c sexp2dsa.c
          pgp-encode.c rsa2openpgp.c
          der-iterator.c der2rsa.c der2dsa.c
          sec-add-1.c sec-sub-1.c sec-tabselect.c
          gmp-glue.c cnd-copy.c
          ecc-mod.c ecc-mod-inv.c
          ecc-mod-arith.c ecc-pp1-redc.c ecc-pm1-redc.c
          ecc-192.c ecc-224.c ecc-256.c ecc-384.c ecc-521.c
          ecc-25519.c
          ecc-size.c ecc-j-to-a.c ecc-a-to-j.c
          ecc-dup-jj.c ecc-add-jja.c ecc-add-jjj.c
          ecc-eh-to-a.c
          ecc-dup-eh.c ecc-add-eh.c ecc-add-ehh.c
          ecc-mul-g-eh.c ecc-mul-a-eh.c
          ecc-mul-g.c ecc-mul-a.c ecc-hash.c ecc-random.c
          ecc-point.c ecc-scalar.c ecc-point-mul.c ecc-point-mul-g.c
          ecc-ecdsa-sign.c ecdsa-sign.c
          ecc-ecdsa-verify.c ecdsa-verify.c ecdsa-keygen.c
          curve25519-mul-g.c curve25519-mul.c curve25519-eh-to-x.c
          eddsa-compress.c eddsa-decompress.c eddsa-expand.c
          eddsa-hash.c eddsa-pubkey.c eddsa-sign.c eddsa-verify.c
          ed25519-sha512-pubkey.c
          ed25519-sha512-sign.c ed25519-sha512-verify.c)

set(OPT_SOURCES fat-x86_64.c fat-arm.c mini-gmp.c)

set(HEADERS aes.h arcfour.h arctwo.h asn1.h blowfish.h
      base16.h base64.h bignum.h buffer.h camellia.h cast128.h
      cbc.h ccm.h chacha.h chacha-poly1305.h ctr.h
      curve25519.h des.h des-compat.h dsa.h dsa-compat.h eax.h
      ecc-curve.h ecc.h ecdsa.h eddsa.h
      gcm.h gosthash94.h hmac.h
      knuth-lfib.h
      macros.h
      md2.h md4.h
      md5.h md5-compat.h
      memops.h memxor.h
      nettle-meta.h nettle-types.h
      pbkdf2.h
      pgp.h pkcs1.h realloc.h ripemd160.h rsa.h
      salsa20.h sexp.h
      serpent.h sha.h sha1.h sha2.h sha3.h twofish.h
      umac.h yarrow.h poly1305.h)

add_library(nettle ${nettle_SOURCES})
# add_library(hogweed ${hogweed_SOURCES})

install(TARGETS 
    nettle 
    # hogweed 
DESTINATION
    RUNTIME DESTINATION bin
    ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib
)

install(FILES 
    ${HEADERS}
    mini-gmp.h
    ${CMAKE_BINARY_DIR}/config.h 
    ${CMAKE_BINARY_DIR}/version.h 
    ${CMAKE_BINARY_DIR}/nettle-stdint.h 
    DESTINATION include/nettle)

set(prefix ${CMAKE_INSTALL_PREFIX})
set(exec_prefix ${CMAKE_INSTALL_PREFIX})
set(libdir ${CMAKE_INSTALL_PREFIX}/lib)
set(includedir ${CMAKE_INSTALL_PREFIX}/include)
configure_file(nettle.pc.in ${CMAKE_BINARY_DIR}/nettle.pc @ONLY)
install(FILES ${CMAKE_BINARY_DIR}/nettle.pc DESTINATION lib/pkgconfig)
