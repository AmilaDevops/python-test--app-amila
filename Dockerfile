FROM elyase/staticpython
WORKDIR /var/www/
COPY index.html ./index.html
EXPOSE 8080
CMD [ "python", "-m", "SimpleHTTPServer", "8080" ]