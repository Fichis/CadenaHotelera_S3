/**
 * Inicializa los eventos para el banner y la estela.
 * Se activa al cargar el DOM.
 *
 * @function
 */
document.addEventListener("DOMContentLoaded", init);

/**
 * Función que configura los eventos del banner y la estela.
 */
function init() {
  const banner = document.querySelector(".banner");
  const estela = document.querySelector(".estela");
  const size = 50;

  banner.addEventListener("mousemove", handleMouseMove);
  banner.addEventListener("mouseenter", handleMouseEnter);
  banner.addEventListener("mouseleave", handleMouseLeave);
}

/**
 * Maneja el movimiento del mouse sobre el banner.
 * Actualiza la posición de la estela y aplica efectos visuales.
 *
 * @param {MouseEvent} e - El evento del mouse.
 */
function handleMouseMove(e) {
  const rect = document.querySelector(".banner").getBoundingClientRect();
  const posX = e.clientX - rect.left;
  const posY = e.clientY - rect.top;

  const estela = document.querySelector(".estela");
  estela.style.left = `${posX - 25}px`;
  estela.style.top = `${posY - 25}px`;

  estela.style.transform = "scale(1.5)";
  estela.style.boxShadow =
    "0 0 50px rgba(255, 223, 0, 1), 0 0 100px rgba(255, 223, 0, 0.5)";
}

/**
 * Maneja el evento cuando el mouse entra en el banner.
 * Hace visible la estela.
 */
function handleMouseEnter() {
  const estela = document.querySelector(".estela");
  estela.style.opacity = "1"; // Muestra la estela
}

/**
 * Maneja el evento cuando el mouse sale del banner.
 * Oculta la estela y restablece sus propiedades.
 */
function handleMouseLeave() {
  const estela = document.querySelector(".estela");
  estela.style.opacity = "0"; // Oculta la estela
  estela.style.transform = "scale(1)";
  estela.style.boxShadow =
    "0 0 50px rgba(255, 223, 0, 1), 0 0 100px rgba(255, 223, 0, 0.5)"; // Restaura la sombra
}
