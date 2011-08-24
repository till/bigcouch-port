# Ports collection makefile for:	bigcouch
# Date created:			24 Aug 2011
# Whom:                         Till Klampaeckel <till@php.net>
#
# $FreeBSD$
#

PORTNAME=	bigcouch
PORTVERSION=	0.3.1
CATEGORIES=	databases
MASTER_SITES=	https://github.com/cloudant/bigcouch/zipball/
EXTRACT_SUFX=

MAINTAINER=	till@php.net
COMMENT=	BigCouch is a clustered version of Apache CouchDB

LIB_DEPENDS=	icudata:${PORTSDIR}/devel/icu \
		js:${PORTSDIR}/lang/spidermonkey \
		curl.6:${PORTSDIR}/ftp/curl
BUILD_DEPENDS=	${LOCALBASE}/bin/help2man:${PORTSDIR}/misc/help2man \
		git:${PORTSDIR}/devel/git

WRKSRC=		${WRKDIR}/cloudant-${PORTNAME}-c5084ae

USERS=		bigcouch
GROUPS=		bigcouch

USE_GMAKE=	yes
USE_LDCONFIG=	yes
PLIST_SUB+=	PORTVERSION="${PORTVERSION}"

OPTIONS=	ERLANG	"Use lang/erlang instead of lang/erlang-lite"	off

MAN1=	couchdb.1 couchjs.1

.include <bsd.port.options.mk>

.if defined(WITH_ERLANG)
ERLANG_PORT=	${PORTSDIR}/lang/erlang
.else
ERLANG_PORT=	${PORTSDIR}/lang/erlang-lite
.endif

BUILD_DEPENDS+=	erlc:${ERLANG_PORT}
RUN_DEPENDS+=	erl:${ERLANG_PORT}

HAS_CONFIGURE=	yes
CONFIGURE_ARGS=	-p ${LOCALBASE}/bigcouch \
		-d /var/db/${PORTNAME}/databases \
		-v /var/db/${PORTNAME}/views \
		-u ${USERS}

post-build:
	@${CAT} ${PKGMESSAGE}

post-install:
.ifndef PACKAGE_BUILDING
	@PKG_PREFIX=${PREFIX} ${SH} ${PKGINSTALL} ${PKGNAME} POST-INSTALL
.endif

post-deinstall:
	@PKG_PREFIX=${PREFIX} ${SH} ${PKGDEINSTALL} ${PKGNAME} POST-DEINSTALL

.include <bsd.port.mk>
