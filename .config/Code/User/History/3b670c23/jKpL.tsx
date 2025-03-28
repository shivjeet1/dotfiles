"use client"

import { useState } from "react"
import Link from "next/link"
import { useRouter, useSearchParams } from "next/navigation"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"
import { GraduationCap, Users } from "lucide-react"
import { ChatBot } from "@/components/chat-bot"
import { useToast } from "@/components/ui/use-toast"

export default function LoginPage() {
  const router = useRouter()
  const searchParams = useSearchParams()
  const defaultRole = searchParams.get("role") || "student"

  const [loading, setLoading] = useState(false)
  const { toast } = useToast()

  const handleLogin = (role: string) => {
    setLoading(true)
    // Simulate authentication
    setTimeout(() => {
      if (role === "student") {
        router.push("/dashboard/student")
      } else {
        router.push("/dashboard/faculty")
      }
      setLoading(false)

      toast({
        title: "Login successful",
        description: `Welcome back to SSGMCE ${role === "student" ? "Student" : "Faculty"} portal.`,
        duration: 3000,
      })
    }, 800)
  }

  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-b from-blue-50 to-white p-4">
      <div className="w-full max-w-md">
        <div className="text-center mb-8">
          <Link href="/" className="inline-flex items-center gap-2">
            <GraduationCap className="h-8 w-8 text-blue-700" />
            <span className="text-xl font-bold text-blue-900">SSGMCE</span>
          </Link>
          <h1 className="text-2xl font-bold text-blue-900 mt-4">Welcome Back</h1>
          <p className="text-gray-600">Sign in to access your account</p>
        </div>

        <Tabs defaultValue={defaultRole} className="w-full">
          <TabsList className="grid w-full grid-cols-2 mb-6">
            <TabsTrigger value="student" className="flex items-center gap-2">
              <GraduationCap className="h-4 w-4" />
              Student
            </TabsTrigger>
            <TabsTrigger value="faculty" className="flex items-center gap-2">
              <Users className="h-4 w-4" />
              Faculty
            </TabsTrigger>
          </TabsList>

          <TabsContent value="student">
            <Card>
              <CardHeader>
                <CardTitle>Student Login</CardTitle>
                <CardDescription>Enter your student ID and password to access your account</CardDescription>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="space-y-2">
                  <Label htmlFor="student-id">Student ID</Label>
                  <Input id="student-id" placeholder="Enter your student ID" />
                </div>
                <div className="space-y-2">
                  <div className="flex items-center justify-between">
                    <Label htmlFor="student-password">Password</Label>
                    <Link href="/forgot-password" className="text-sm text-blue-600 hover:underline">
                      Forgot password?
                    </Link>
                  </div>
                  <Input id="student-password" type="password" placeholder="Enter your password" />
                </div>
              </CardContent>
              <CardFooter>
                <Button
                  className="w-full bg-blue-700 hover:bg-blue-800"
                  onClick={() => handleLogin("student")}
                  disabled={loading}
                >
                  {loading ? "Signing in..." : "Sign In"}
                </Button>
              </CardFooter>
            </Card>
          </TabsContent>

          <TabsContent value="faculty">
            <Card>
              <CardHeader>
                <CardTitle>Faculty Login</CardTitle>
                <CardDescription>Enter your faculty ID and password to access your account</CardDescription>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="space-y-2">
                  <Label htmlFor="faculty-id">Faculty ID</Label>
                  <Input id="faculty-id" placeholder="Enter your faculty ID" />
                </div>
                <div className="space-y-2">
                  <div className="flex items-center justify-between">
                    <Label htmlFor="faculty-password">Password</Label>
                    <Link href="/forgot-password" className="text-sm text-blue-600 hover:underline">
                      Forgot password?
                    </Link>
                  </div>
                  <Input id="faculty-password" type="password" placeholder="Enter your password" />
                </div>
              </CardContent>
              <CardFooter>
                <Button
                  className="w-full bg-blue-700 hover:bg-blue-800"
                  onClick={() => handleLogin("faculty")}
                  disabled={loading}
                >
                  {loading ? "Signing in..." : "Sign In"}
                </Button>
              </CardFooter>
            </Card>
          </TabsContent>
        </Tabs>

        <div className="text-center mt-6">
          <p className="text-sm text-gray-600">
            Having trouble logging in?{" "}
            <Link href="/contact" className="text-blue-600 hover:underline">
              Contact support
            </Link>
          </p>
        </div>
      </div>

      <ChatBot />

      <div className="fixed bottom-0 left-0 right-0 bg-gray-100 py-2 text-center text-sm text-gray-600">
        Made by yashpatilmali
      </div>
    </div>
  )
}

