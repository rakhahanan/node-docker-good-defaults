# If you're doing anything beyond your local machine, please pin this to a specific version at https://hub.docker.com/_/node/
# Always use slim. If you need additional packages, add them with apt
# Alpine variants are not offically supported by Node.js, so we use the default debian variant
FROM node:18-slim
ENV WORKDIR /usr/src/app/
WORKDIR $WORKDIR
COPY package*.json $WORKDIR
RUN npm install

FROM node:18-slim
ENV USER node
ENV WORKDIR /home/$USER/app
WORKDIR $WORKDIR
COPY --from=0 /usr/src/app/node_modules node_modules
RUN chown $USER:$USER $WORKDIR
COPY --chown=node . $WORKDIR
# In production environment uncomment the next line
#RUN chown -R $USER:$USER /home/$USER && chmod -R g-s,o-rx /home/$USER && chmod -R o-wrx $WORKDIR
# Then all further actions including running the containers should be done under non-root user.
USER $USER
EXPOSE 6000
CMD [ "node", "server.js" ]