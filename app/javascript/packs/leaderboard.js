import consumer from "./consumer";

const contestId = document.getElementById('leaderboard').dataset.contestId; // Assuming you have the contest ID in the HTML

consumer.subscriptions.create({ channel: "LeaderboardChannel", contest_id: contestId }, {
  received(data) {
    // Update the leaderboard with the new data
    let leaderboardContainer = document.getElementById('leaderboard');
    leaderboardContainer.innerHTML = '';

    data.contestants.forEach(contestant => {
      let contestantElement = document.createElement('div');
      contestantElement.innerHTML = `${contestant.name} - Votes: ${contestant.vote_count}`;
      leaderboardContainer.appendChild(contestantElement);
    });
  }
});
