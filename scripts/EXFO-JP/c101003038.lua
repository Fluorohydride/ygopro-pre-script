--エクスコード・トーカー
--Excode Talker
--Scripted by Eerie Code
function c101003038.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_CYBERS),2)
	--lock zones
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101003038,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,101003038)
	e1:SetCondition(c101003038.lzcon)
	e1:SetOperation(c101003038.lzop)
	c:RegisterEffect(e1)
	--atk up/effect indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c101003038.tgtg)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(500)
	c:RegisterEffect(e3)
end
function c101003038.lzcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and Duel.GetLocationCount(tp,LOCATION_MZONE)+Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c101003038.lzfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c101003038.lzop(e,tp,eg,ep,ev,re,r,rp)
	local fc=Duel.GetLocationCount(tp,LOCATION_MZONE)+Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	local ct=Duel.GetMatchingGroupCount(c101003038.lzfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local v=math.min(fc,ct)
	if v<1 then return end
	--disable field
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetLabel(v)
	e1:SetOperation(c101003038.disop)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	e:GetHandler():RegisterEffect(e1)
end
function c101003038.disop(e,tp)
	local c=e:GetLabel()
	local dis1=Duel.SelectDisableField(tp,1,LOCATION_MZONE,LOCATION_MZONE,0)
	if c>1 and Duel.SelectYesNo(tp,aux.Stringid(101003038,1)) then
		local dis2=Duel.SelectDisableField(tp,1,LOCATION_MZONE,LOCATION_MZONE,dis1)
		dis1=bit.bor(dis1,dis2)
	end
	return dis1
end
function c101003038.tgtg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end
