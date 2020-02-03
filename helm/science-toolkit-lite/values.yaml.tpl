domain: toolkit.local

sharedVolume:
  name: received-data-lite
  storageClassName: standard
  path: /sci-toolkit-lite/received-data-lite

jupyterhub:
  credentials:
    username: test
    password: test
  hub:
    cookieSecret: "61cffae7cfa30a05086fd916ec27f06b1388ada9302356c090c735b00082ad4a"
    extraConfig: |-
      c.Spawner.ip = '0.0.0.0'
      c.Spawner.cmd = ['jupyter-labhub']
  proxy:
    secretToken: "3bcee88b0a1aea302b9757fd9dcc8579469f86bac91229ee5dd0262f4b3d274d"
    service:
      type: ClusterIP
  cull:
    timeout: 259200
  ingress:
    enabled: false
  singleuser:
    defaultUrl: "/lab"
    cloudMetadata:
      enabled: true
    image:
      name: terminus7/jupyterlab-gpu
      tag: 1.4.0-test
    storage:
      extraVolumes:
        - name: received-data
          persistentVolumeClaim:
            claimName: received-data-lite-claim
      extraVolumeMounts:
        - mountPath: /home/jovyan/projects
          name: received-data-lite

minio:
  accessKey: minio
  secretKey: minio123
  persistence:
    storageClass: standard
    existingClaim: received-data-lite-claim
    accessMode: ReadWriteMany
  ingress:
    enabled: true
    hosts:
      - minio.local
    annotations:
      nginx.ingress.kubernetes.io/proxy-body-size: "1000000m"

mlflow:
  name: mlflow-tracking-server
  image: 
    repository: terminus7/mlflow
    tag: 1.0.0
    pullPolicy: IfNotPresent
  service:
    port: 5000
  host: mlflow.local
  volume:
    size: 10Gi
  s3: 
    bucket: mlflow-artifacts
