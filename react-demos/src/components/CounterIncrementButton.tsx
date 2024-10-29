import { useComplexThing } from "../useComplexThing";

function CounterIncrementButton() {
  const { incrementCounter } = useComplexThing();

  return (<div>
    <h4>Counter Increment Button</h4>
    <button onClick={incrementCounter}>Increment</button>
  </div>);

}

export default CounterIncrementButton;
