import React from 'react';
import ReactDOM from 'react-dom';

class Greet extends React.Component {
    render() {
        return (
            <div>Hello, {this.props.name}.</div>
        );
    }
}

ReactDOM.render(
    <Greet name="webpack" />,
    document.getElementById('content')
);