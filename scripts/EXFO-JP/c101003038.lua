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
	e1:SetTarget(c101003038.lztg)
	e1:SetOperation(c101003038.lzop)
	c:RegisterEffect(e1)
	--atk up/indestructable
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
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c101003038.lzfilter(c)
	return c:GetSequence()>4
end
function c101003038.lztg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(c101003038.lzfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=ct end
	local dis=Duel.SelectDisableField(tp,ct,LOCATION_MZONE,LOCATION_MZONE,0)
	e:SetLabel(dis)
end
function c101003038.lzop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetOperation(c101003038.disop)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	e1:SetLabel(e:GetLabel())
	e:GetHandler():RegisterEffect(e1)
end
function c101003038.disop(e,tp)
	return e:GetLabel()
end
function c101003038.tgtg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end
