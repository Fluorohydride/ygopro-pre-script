--エピュアリィ・プランプ
--Scripted by JoyJ
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,100419023)
	--xyz summon
	aux.AddXyzProcedure(c,nil,2,2)
	c:EnableReviveLimit()
	--be material from grave
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e1:SetCondition(s.gmatcon)
	e1:SetTarget(s.gmattg)
	e1:SetOperation(s.gmatop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCondition(s.gmatcon2)
	c:RegisterEffect(e2)
	--be material from szone
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(3)
	e3:SetCondition(s.matcon)
	e3:SetTarget(s.mattg)
	e3:SetOperation(s.matop)
	c:RegisterEffect(e3)
end
function s.gmatcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,100419023)
end
function s.gmatcon2(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,100419023)
end
function s.gmattgfilter(c,sc)
	return c:IsCanOverlay() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function s.gmattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(s.gmattgfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	Duel.SelectTarget(tp,s.gmattgfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,2,nil,c)
end
function s.gmatop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(aux.NecroValleyFilter(Card.IsRelateToChain),nil,0)
	g=g:Filter(aux.NOT(Card.IsImmuneToEffect),nil,e)
	if #g>0 then
		Duel.Overlay(e:GetHandler(),g)
	end
end
function s.matcon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return (loc & LOCATION_ONFIELD)>0 and re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and re:IsActiveType(TYPE_QUICKPLAY) and re:GetHandler():IsSetCard(0x28c)
end
function s.mattg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsCanOverlay() end
	re:GetHandler():CreateEffectRelation(e)
end
function s.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=re:GetHandler()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		tc:CancelToGrave()
		Duel.Overlay(c,tc)
		if c:GetOverlayGroup():IsContains(tc) then
			if Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp)
				and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
				local rc=tg:GetFirst()
				if Duel.Remove(rc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
					tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e1:SetCode(EVENT_PHASE+PHASE_END)
					e1:SetReset(RESET_PHASE+PHASE_END)
					e1:SetLabelObject(rc)
					e1:SetCountLimit(1)
					e1:SetCondition(s.retcon)
					e1:SetOperation(s.retop)
					Duel.RegisterEffect(e1,tp)
				end
			end
		else
			tc:CancelToGrave(false)
		end
	end
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetFlagEffect(id)~=0
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
