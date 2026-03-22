// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

const initializeMenuToggle = () => {
  document.querySelectorAll("[data-menu]").forEach((container) => {
    if (container.dataset.menuInitialized === "true") return

    const button = container.querySelector("[data-menu-button]")
    const panel = container.querySelector("[data-menu-panel]")

    if (!button || !panel) return

    const closeMenu = () => {
      panel.classList.remove("is-open")
      button.setAttribute("aria-expanded", "false")
    }

    button.addEventListener("click", () => {
      const expanded = panel.classList.toggle("is-open")
      button.setAttribute("aria-expanded", String(expanded))
    })

    window.addEventListener("resize", () => {
      if (window.innerWidth > 820) closeMenu()
    })

    container.dataset.menuInitialized = "true"
  })
}

const initializeModalToggle = () => {
  document.querySelectorAll("[data-modal-root]").forEach((root) => {
    if (root.dataset.modalInitialized === "true") return

    const dialog = root.querySelector("[data-modal-dialog]")
    const openers = document.querySelectorAll(`[data-modal-open="${root.id}"]`)
    const closers = root.querySelectorAll("[data-modal-close]")

    if (!dialog) return

    const openModal = () => {
      root.hidden = false
      root.classList.add("is-open")
      document.body.classList.add("modal-open")
    }

    const closeModal = () => {
      root.classList.remove("is-open")
      document.body.classList.remove("modal-open")
      root.hidden = true
    }

    openers.forEach((opener) => {
      opener.addEventListener("click", (event) => {
        event.preventDefault()
        openModal()
      })
    })

    closers.forEach((closer) => {
      closer.addEventListener("click", closeModal)
    })

    root.addEventListener("click", (event) => {
      if (event.target === root) closeModal()
    })

    document.addEventListener("keydown", (event) => {
      if (event.key === "Escape" && root.classList.contains("is-open")) closeModal()
    })

    root.dataset.modalInitialized = "true"
  })
}

const initializePreservedScroll = () => {
  const storageKey = "adminInquiriesScrollY"
  const markerKey = "adminInquiriesRestorePending"
  const isAdminInquiriesPage = window.location.pathname === "/admin/inquiries"

  if (isAdminInquiriesPage && sessionStorage.getItem(markerKey) === "true") {
    const savedPosition = Number(sessionStorage.getItem(storageKey))

    if (!Number.isNaN(savedPosition)) {
      requestAnimationFrame(() => window.scrollTo(0, savedPosition))
    }

    sessionStorage.removeItem(markerKey)
    sessionStorage.removeItem(storageKey)
  }

  document.querySelectorAll("[data-preserve-scroll]").forEach((element) => {
    if (element.dataset.preserveScrollInitialized === "true") return

    const rememberScroll = () => {
      sessionStorage.setItem(storageKey, String(window.scrollY))
      sessionStorage.setItem(markerKey, "true")
    }

    if (element.tagName === "FORM") {
      element.addEventListener("submit", rememberScroll)
    } else {
      element.addEventListener("click", rememberScroll)
    }

    element.dataset.preserveScrollInitialized = "true"
  })
}

document.addEventListener("turbo:load", initializeMenuToggle)
document.addEventListener("turbo:load", initializeModalToggle)
document.addEventListener("turbo:load", initializePreservedScroll)
