const navToggle = document.querySelector(".nav__toggle"),
    navMenu = document.querySelector(".nav__menu"),
    navClose = document.querySelector(".nav__close"),
    navList = document.querySelectorAll(".nav__list"),
    allFaqs = document.querySelectorAll(".all_faqs"),
    themeBtn = document.getElementById("theme-button");

navToggle.addEventListener("click", () => {
    navMenu.classList.add("show-menu");
    navToggle.style.display = "none";
    changeTheme.style.display = "none";
});

navClose.addEventListener("click", () => {
    navMenu.classList.remove("show-menu");
    navToggle.style.display = "block";
    changeTheme.style.display = "block";
});

navList.forEach((item) => {
    item.addEventListener("click", () => {
        navMenu.classList.remove("show-menu");
        navToggle.style.display = "none";
        changeTheme.style.display = "block";
    });
});

allFaqs.forEach(item => {
    item.addEventListener("click", () => {
        item.classList.toggle("active");
    });
});

themeBtn.addEventListener("click", () => {
    document.body.classList.toggle("light-mode");
});