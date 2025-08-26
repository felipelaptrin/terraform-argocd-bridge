{{- define "cluster_addons.commonLabels" -}}
argocd.argoproj.io/secret-type: cluster
{{- range $k, $v := .Values.secret.extraLabels }}
{{ $k }}: {{ $v | quote }}
{{- end }}
{{- end }}
