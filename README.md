## Personal Blog

Personal blog and website, accessible at [https://paulswithers.github.io](https://paulswithers.github.io).

Build docker image as "mkdocs-enhanced" with `docker build -t=docs-paulswithers/mkdocs .`
Preview locally with `docker run --rm -it -v %cd%:/docs -p 8000:8000 paulswithers/mkdocs`.