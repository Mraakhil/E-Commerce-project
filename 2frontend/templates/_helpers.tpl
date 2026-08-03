{{/*
Expand the name of the chart.
*/}}
{{- define "opentelemetry-frontendproxy.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
Create a fullname.
*/}}
{{- define "opentelemetry-frontendproxy.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name (include "opentelemetry-frontendproxy.name" .) | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Chart label
*/}}
{{- define "opentelemetry-frontendproxy.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "opentelemetry-frontendproxy.labels" -}}
helm.sh/chart: {{ include "opentelemetry-frontendproxy.chart" . }}
app.kubernetes.io/name: {{ include "opentelemetry-frontendproxy.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/component: frontendproxy
opentelemetry.io/name: {{ include "opentelemetry-frontendproxy.fullname" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "opentelemetry-frontendproxy.selectorLabels" -}}
app.kubernetes.io/name: {{ include "opentelemetry-frontendproxy.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
opentelemetry.io/name: {{ include "opentelemetry-frontendproxy.fullname" . }}
{{- end }}