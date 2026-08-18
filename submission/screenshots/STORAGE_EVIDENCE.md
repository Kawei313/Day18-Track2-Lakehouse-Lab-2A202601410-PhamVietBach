# Lightweight storage evidence (Windows)

The eight notebooks were executed on Windows using the lightweight path. The
following PowerShell command was used to inspect the local lakehouse:

```powershell
Get-ChildItem -Recurse -Directory _lakehouse
Get-Content _lakehouse\bronze\llm_calls_raw\_delta_log\00000000000000000000.json
```

Observed layout includes `bronze`, `silver`, `gold`, `scratch`, `iceberg`, and
`blobs`. Delta transaction logs are present under each Delta table's
`_delta_log` directory. The first Bronze commit records a Delta-RS write of
200,000 rows and its Parquet add action, establishing the storage-layer
evidence requested by the rubric.

The executed `.ipynb` files in `notebooks/` retain the corresponding outputs.
