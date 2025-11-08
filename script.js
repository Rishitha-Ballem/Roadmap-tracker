const topics = [
    "Git & GitHub Basics",
    "Linux Commands",
    "Docker & Containers",
    "Jenkins CI/CD Pipelines",
    "Terraform Infrastructure as Code",
    "AWS EC2, IAM & VPC",
    "Monitoring with CloudWatch",
];

let progress = JSON.parse(localStorage.getItem("progress")) || Array(topics.length).fill(false);

function updateUI() {
    const container = document.getElementById("topics-container");
    container.innerHTML = "";

    topics.forEach((topic, index) => {
        const card = document.createElement("div");
        card.className = "topic-card";

        card.innerHTML = `
            <span>${topic}</span>
            <button class="${progress[index] ? 'completed' : ''}" onclick="toggle(${index})">
                ${progress[index] ? "Completed ✅" : "Mark Done"}
            </button>
        `;

        container.appendChild(card);
    });

    const completedCount = progress.filter(Boolean).length;
    const percent = Math.round((completedCount / topics.length) * 100);

    document.getElementById("progress-bar").style.width = percent + "%";
    document.getElementById("progress-text").textContent = percent + "% Completed";
}

function toggle(index) {
    progress[index] = !progress[index];
    localStorage.setItem("progress", JSON.stringify(progress));
    updateUI();
}

updateUI();
