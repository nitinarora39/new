FROM python:3.6-stretch
ENV NGINX_VERSION 1.15.7-1~stretch
RUN apt-get update -y
RUN apt-get -y install nginx
RUN unlink /etc/nginx/sites-enabled/default
COPY new.conf /etc/nginx/sites-available
RUN ln -s /etc/nginx/sites-available/new.conf /etc/nginx/sites-enabled/
ENV NGINX_MAX_UPLOAD 0
ENV LISTEN_PORT 80
EXPOSE 80
WORKDIR /home/python/
ADD . /home/python/
RUN pip install -r requirements.txt
RUN python manage.py migrate 
RUN python manage.py runserver
CMD ["nginx","-g","daemon off;"]




FROM python:3.6-stretch
RUN apt-get update -y
ENV LISTEN_PORT 80
EXPOSE 80
WORKDIR /home/python/
ADD . /home/python/
RUN pip install -r requirements.txt
RUN python manage.py migrate
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]