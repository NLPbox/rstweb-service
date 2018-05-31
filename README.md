# rstweb-service

This docker container allows you to build, install and run the
[rstWeb](https://corpling.uis.georgetown.edu/rstweb/info/)
Rhetorical Structure Theory annotation tool (Zeldes 2016)
in a docker container.

Specifically, this will run the version 2.0.0 of `rstWeb` with an additional
REST API for importing, opening and exporting rs3 files.

Unlike [rstweb-docker](https://github.com/NLPbox/rstweb-docker),
this container runs the "local" version of `rstWeb`.

Note: The rs3 files you upload, edit and store in `rstWeb` will
only exist as long as the container is running. In order to persist the
data, you would need to [bind-mount](https://docs.docker.com/storage/bind-mounts/)
an empty SQLite database into `/opt/rstweb/rstweb.db`.

# Usage

To build, install and run `rstweb-service`, simply type:

```
docker run -p 9000:8080 -ti nlpbox/rstweb-service
```

Inside the container, `rstWeb` (and the added `rstweb-service` REST API)
listens on port 8080, but we'll map it to port 9000 of our host system
(`localhost` / `127.0.0.1`).

Now, you can create a project called `rst-workbench` in the running
`rstWeb` instance:

```
curl -XPOST http://127.0.0.1:9000/add_project -F name="rst-workbench"
```

The server will reply with the list of projects that are currently available
in `rstWeb`:

```
{"projects": ["rst-workbench"]}
```

To import the rs3 file `/path/to/source.rs3` into the project `rst-workbench`
and store it there under the name `target.rs3`, type:

```
curl -XPOST http://127.0.0.1:9000/import_rs3_file \
     -F rs3_file=@/path/to/source.rs3 -F project="rst-workbench" -F file_name=target.rs3
```

Afterwards, you can open the document `target.rs3` in your browser
under the URL [http://127.0.0.1:9000/open] and edit it in the Structure
editor. Don't forget to save your changes using the `save` button!

You can either download the edited file by clicking on the `</> xml`
button in the Structure editor or retrieve it programmatically (this is
what `rst-workbench` does under the hood):

```
curl -XGET "http://127.0.0.1:9000/export_rs3_file?file_name=target.rs3&project=rst-workbench"
```

# Citation

Zeldes, Amir (2016).
[rstWeb - A Browser-based Annotation Interface for Rhetorical Structure Theory and Discourse Relations](http://aclweb.org/anthology/N/N16/N16-3001.pdf).  
In: Proceedings of NAACL-HLT 2016 System Demonstrations.
San Diego, CA, 1-5.
