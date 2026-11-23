"use strict";

// Cliente minimo de la API falsa. Genera trafico observable para la futura captura autorizada.
const out = document.getElementById("out");

async function show(url) {
  out.textContent = "Cargando...";
  try {
    const response = await fetch(url, { headers: { Accept: "application/json" } });
    const payload = await response.json();
    out.textContent = JSON.stringify(payload, null, 2);
  } catch (error) {
    out.textContent = "Error de lectura: " + error.message;
  }
}

document.getElementById("load").addEventListener("click", () => show("/api/catalog"));
document.getElementById("detail").addEventListener("click", () => show("/api/catalog/2"));
