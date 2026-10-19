{{- define "lighthouse.labels" -}}
app.kubernetes.io/name: lighthouse
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "lighthouse.selectorLabels" -}}
app.kubernetes.io/name: lighthouse-app
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
