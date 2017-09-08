{{- define "geomapfish.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "geomapfish.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Sets the apiVersion string for openshift api group proxy usage
*/}}
{{- define "geomapfish.api_version" -}}
{{- if eq .Values.clusterType "openshift" -}}
{{- printf "openshift.org/v1" -}}
{{- else -}}
{{- printf "v1" -}}
{{- end -}}
{{- end -}}

{{- define "geomapfish.release_labels" }}
app: {{ template "geomapfish.name" . }}
chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
release: "{{ .Release.Name }}"
heritage: {{ .Release.Service }}
tag: "{{ .Values.imageTag }}"
{{- end }}

{{- define "geomapfish.pod_envs" }}
env:
- name: PG_OSM_CONN_STRING
  value: >-
    {{ .Values.db.type }}://{{ .Values.db.user }}:{{ .Values.db.pass }}@{{ .Values.db.host }}:{{ .Values.db.port }}/{{ .Values.db.osm_db }}
- name: PG_DEMO_CONN_STRING
  value: >-
    {{ .Values.db.type }}://{{ .Values.db.user }}:{{ .Values.db.pass }}@{{ .Values.db.host }}:{{ .Values.db.port }}/{{ .Values.db.gmf_db }}
- name: MAPSERVER_URL
  value: >-
    http://{{ template "geomapfish.fullname" . }}-mapserver.{{ .Release.Namespace }}.svc:{{ .Values.apps.mapserver.port}}
- name: PRINT_URL_PRINT_DEMO
  value: >-
    http://{{ template "geomapfish.fullname" . }}-print.{{ .Release.Namespace }}.svc:{{ .Values.apps.print.port}}/print/demo
- name: WSGI_TEST_URL
  value: >-
    http://{{ template "geomapfish.fullname" . }}-wsgi.{{ .Release.Namespace }}.{{ .Values.domain }}
{{- end }}
