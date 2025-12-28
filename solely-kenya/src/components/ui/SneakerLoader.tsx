interface SneakerLoaderProps {
    message?: string;
    size?: "sm" | "md" | "lg";
    fullScreen?: boolean;
}

export const SneakerLoader = ({
    message = "Loading...",
    size = "md",
    fullScreen = true
}: SneakerLoaderProps) => {
    const sizeClasses = {
        sm: { ring: "w-16 h-16", icon: "w-6 h-6", shadow: "w-10 h-1.5" },
        md: { ring: "w-24 h-24", icon: "w-10 h-10", shadow: "w-16 h-2" },
        lg: { ring: "w-32 h-32", icon: "w-14 h-14", shadow: "w-20 h-2.5" },
    };

    const { ring, icon, shadow } = sizeClasses[size];

    return (
        <div className={`flex flex-col items-center justify-center gap-6 ${fullScreen ? "min-h-screen" : "py-12"}`}>
            {/* Premium Shoe Loader */}
            <div className="relative">
                {/* Outer spinning ring */}
                <div className={`${ring} rounded-full border-4 border-muted`}></div>
                <div className={`absolute inset-0 ${ring} rounded-full border-4 border-primary border-t-transparent animate-spin`}></div>

                {/* Floating sneaker icon in center */}
                <div className="absolute inset-0 flex items-center justify-center">
                    <div className="animate-bounce">
                        <svg
                            className={`${icon} text-primary`}
                            viewBox="0 0 64 64"
                            fill="currentColor"
                        >
                            <path d="M60 38c0 0-4-2-8-2s-8 2-12 2-8-2-12-2-8 2-12 2-8-2-8-2c-2 0-4 2-4 4v4c0 2 2 4 4 4h48c2 0 4-2 4-4v-4c0-2-2-4-4-4zM12 44c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2zm10 0c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2zm10 0c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2zM56 32l-8-16c-1-2-3-4-6-4H22c-3 0-5 2-6 4L8 32h48z" />
                        </svg>
                    </div>
                </div>
            </div>

            {/* Pulsing shadow beneath */}
            <div className={`${shadow} bg-primary/20 rounded-full animate-pulse`}></div>

            {/* Loading text */}
            <p className="text-muted-foreground text-sm font-medium">{message}</p>
        </div>
    );
};
