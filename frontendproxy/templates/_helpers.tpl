{{/*
Expand the name of the chart.
*/}}
{{- define "opentelemetry-frontendproxy.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "opentelemetry-frontendproxy.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name (include "opentelemetry-frontendproxy.name" .) | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "opentelemetry-frontendproxy.labels" -}}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
{{ include "opentelemetry-frontendproxy.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "opentelemetry-frontendproxy.selectorLabels" -}}
app.kubernetes.io/name: {{ include "opentelemetry-frontendproxy.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
opentelemetry.io/name: {{ include "opentelemetry-frontendproxy.fullname" . }}
{{- end }}