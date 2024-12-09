import { useEffect } from "react";
import CounterDisplay from "./CounterDisplay";
import CounterIncrementButton from "./CounterIncrementButton";
import { useComplexThing } from "../useComplexThing";
import { useMyContext } from "../myContext";

function CounterManager() {

  const { anotherFunction } = useComplexThing()
  const { func } = useMyContext();

  useEffect(() => {
    anotherFunction(func)
  }, [anotherFunction, func])

  return (<div>
    <h3>Counter Manager</h3>
    <CounterDisplay />
    <CounterIncrementButton />
  </div>);
}

export default CounterManager;
