# Redis Client

## GNU Cobol Manual

- https://gnucobol.sourceforge.io/doc/gnucobol.pdf
- old but gold: https://gnucobol.sourceforge.io/guides/GnuCOBOL%202.2%20NOV2017%20Programmers%20Guide%20(US%20Letter).pdf
- https://www.ibm.com/docs/en/zos/2.2.0?topic=definitions-cobol-data-type

## Dependencies

- A Posix Compliant Environment
- GnuCobol 3
- C11 compiler (clang or gcc)
- Make

### Dependencies - Optional Infrastructure Dependencies

- docker
- docker-compose

## Setup

```
export COBC=/path/to/my/cobc
```

### Setup - Infrastructure

```
docker-compose up -d
```

> Version 3 required

## Build

```
make
```

## Run

```
make run
```

## Soft Cleanup

```
make clean
```

## Full Cleanup

```
make distclean
```
