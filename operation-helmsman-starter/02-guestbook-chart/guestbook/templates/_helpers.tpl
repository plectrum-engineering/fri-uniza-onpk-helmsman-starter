{{/*
Chart name + version, used in the helm.sh/chart label.
*/}}
{{- define "guestbook.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels added to every object.
*/}}
{{- define "guestbook.labels" -}}
helm.sh/chart: {{ include "guestbook.chart" . }}
app.kubernetes.io/part-of: guestbook
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- /* TODO (M2.3): add a label onpk.io/environment with the value of .Values.environment (quoted) */}}
{{- end }}

{{/*
TODO (M2.2): define a helper "guestbook.image" that receives an image dict
{repository, tag, digest} and renders:
  repository@digest   when digest is set
  repository:tag      otherwise (fail with `required` if the tag is empty)
Usage: {{ include "guestbook.image" .Values.frontend.image }}

Until you write it, this placeholder only supports tags:
*/}}
{{- define "guestbook.image" -}}
{{ .repository }}:{{ .tag }}
{{- end }}
