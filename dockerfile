FROM squidfunk/mkdocs-material
RUN pip install mkdocs-awesome-pages-plugin mkdocs-markdownextradata-plugin 
RUN pip install mkdocs-rss-plugin