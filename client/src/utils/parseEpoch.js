export default function(epoch) {
    let date = new Date(epoch * 1000);
    return `${date.getFullYear()}/${date.getMonth() + 1}/${date.getDate()}`;
}