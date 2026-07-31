export interface ButtonClickOptions {
  label?: string;
  onCount?: (count: number) => void;
}

/**
 * Creates a click handler that counts clicks and logs the button label.
 * Framework-agnostic: works with a plain DOM listener or a React onClick prop.
 */
export function createButtonClickHandler(options: ButtonClickOptions = {}) {
  const { label = "button", onCount } = options;
  let count = 0;

  return (event: MouseEvent): void => {
    event.preventDefault();
    count += 1;

    console.log(`${label} clicked (${count})`);
    onCount?.(count);
  };
}

export default createButtonClickHandler;
