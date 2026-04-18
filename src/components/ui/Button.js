import { cn } from "@/lib/utils";

/**
 * KLICUS UI: Button
 * Reusable, accessible and versatile button component.
 */
export default function Button({ 
  children, 
  className, 
  variant = "primary", 
  size = "md", 
  ...props 
}) {
  const variants = {
    primary: "bg-primary text-primary-foreground hover:brightness-110 active:scale-[0.98]",
    secondary: "bg-secondary text-secondary-foreground border border-border hover:bg-muted active:scale-[0.98]",
    outline: "border border-input bg-transparent hover:bg-muted hover:text-muted-foreground active:scale-[0.98]",
    ghost: "hover:bg-muted hover:text-muted-foreground",
    accent: "bg-accent text-accent-foreground hover:brightness-110 active:scale-[0.98]",
  };

  const sizes = {
    sm: "px-3 py-1.5 text-xs",
    md: "px-6 py-2.5 text-sm",
    lg: "px-8 py-3.5 text-base",
    icon: "p-2",
  };

  return (
    <button
      className={cn(
        "inline-flex items-center justify-center gap-2 rounded-md font-semibold transition-all duration-200 outline-none ring-primary focus-visible:ring-2 disabled:opacity-50 disabled:pointer-events-none",
        variants[variant],
        sizes[size],
        className
      )}
      {...props}
    >
      {children}
    </button>
  );
}
