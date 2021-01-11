--アンカモフライト

--Scripted by mallu11
function c101104026.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101104026,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,101104026)
	e1:SetCondition(c101104026.drcon)
	e1:SetTarget(c101104026.drtg)
	e1:SetOperation(c101104026.drop)
	c:RegisterEffect(e1)
	--spsummon condition
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCountLimit(1,101104126+EFFECT_COUNT_CODE_OATH)
	e3:SetCondition(c101104026.hspcon)
	c:RegisterEffect(e3)
	--redirect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCondition(c101104026.recon)
	e4:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e4)
end
function c101104026.drfilter(c)
	return c:IsFaceup() and c:IsCode(101104026)
end
function c101104026.drcon(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)
	return ct==0 or ct==Duel.GetMatchingGroupCount(c101104026.drfilter,tp,LOCATION_EXTRA,0,nil)
end
function c101104026.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c101104026.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c101104026.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)
	return ct==Duel.GetMatchingGroupCount(c101104026.drfilter,tp,LOCATION_EXTRA,0,nil) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c101104026.recon(e)
	return e:GetHandler():IsLocation(LOCATION_MZONE) and e:GetHandler():IsFaceup()
end
