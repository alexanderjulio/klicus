import { clsx } from "clsx";
import { twMerge } from "tailwind-merge";

/**
 * Professional Utility for tailwind class merging
 * Handles conflicting classes and conditional logic cleanly.
 */
export function cn(...inputs) {
  return twMerge(clsx(inputs));
}
