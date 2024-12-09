import { useEffect } from "react";
import CounterDisplay from "./CounterDisplay";
import CounterIncrementButton from "./CounterIncrementButton";
import { useComplexThing } from "../useComplexThing";
import { useMyContext } from "../myContext";

function CounterManager() {

  const { changeStateSomehow } = useComplexThing()
  const { func2 } = useMyContext();

  useEffect(() => {
    // add the message handler to the socket service to handle incoming ws messages:
    func2(changeStateSomehow)
  }, [changeStateSomehow, func2]);

  return (<div>
    <h3>Counter Manager</h3>
    <CounterDisplay />
    <CounterIncrementButton />
  </div>);
}

export default CounterManager;
