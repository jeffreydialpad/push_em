Use this dockerfile to build a docker image that creates a linux environment for g2p based tasks.

The mounted directory should have lexicon.txt (base lexicon), text (training corpus) and the g2p.fst (g2p model). 

Usage:
To build: docker build -t us.gcr.io/talkiq-data/g2p-env  .
To run: docker run  -v <dir_to_mount>:/app -it us.gcr.io/talkiq-data/g2p-env --entrypoint "/bin/bash get_oovs.py"
